//
//  RewindJourneyViewModel.swift
//  RewindJourney
//
//  Created by 전민건 on 11/30/23.
//

import Combine
import Foundation
import MusicKit

import MSDomain
import MSLogger

public final class RewindJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case startAutoPlay
        case stopAutoPlay
        case toggleMusic(isPlaying: Bool)
        case photoIndexDidChange(index: Int)
    }
    
    public struct State {
        // Passthrough
        let timerDidEnded = PassthroughSubject<Void, Never>()
        
        // CurrentValue
        let photoURLs: CurrentValueSubject<[URL], Never>
        let musicMetadata: CurrentValueSubject<Music, Never>
        let selectedSong = CurrentValueSubject<Song?, Never>(nil)
        let albumCoverImageData = CurrentValueSubject<Data?, Never>(nil)
        
        let presentingPhotoIndex = CurrentValueSubject<Int, Never>(.zero)
        let isSongPlaying = CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - Properties
    
    private let spotRepository: SpotRepository
    private let songRepository: SongRepository
    
    public var state: State
    
    // MARK: - Properties: Timer
    
    private var timerTimeInterval: TimeInterval = 10.0
    private var timer: AnyCancellable?
    
    // MARK: - Initializer
    
    public init(photoURLs: [URL],
                music: Music,
                spotRepository: SpotRepository,
                songRepository: SongRepository) {
        self.spotRepository = spotRepository
        self.songRepository = songRepository
        self.state = State(photoURLs: CurrentValueSubject<[URL], Never>(photoURLs),
                           musicMetadata: CurrentValueSubject<Music, Never>(music))
    }
    
}

// MARK: - Interface: Actions

extension RewindJourneyViewModel {
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.fetchSpotPhotos()
            
            let musicMetadata = self.state.musicMetadata.value
            self.fetchSong(byID: musicMetadata.id)
            self.fetchAlbumCover(from: musicMetadata.albumCover?.url)
        case .startAutoPlay:
            self.startTimer()
        case .stopAutoPlay:
            self.stopTimer()
        case .toggleMusic(let isPlaying):
            self.state.isSongPlaying.send(isPlaying)
        case .photoIndexDidChange(let index):
            self.state.presentingPhotoIndex.send(index)
        }
    }

}

// MARK: - Functions: Music

private extension RewindJourneyViewModel {
    
    func fetchSpotPhotos() {
        Task(priority: .background) {
            let photoURLs = self.state.photoURLs.value
            
            for photoURL in photoURLs {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await self.spotRepository.fetchSpotPhoto(from: photoURL)
                    }
                }
            }
        }
    }
    
    func fetchSong(byID id: String) {
        Task(priority: .background) {
            let result = await self.songRepository.fetchSong(withID: id)
            switch result {
            case .success(let song):
                #if DEBUG
                MSLogger.make(category: .rewindJourney).debug("음악을 찾았습니다: \(song)")
                #endif
                
                if let duration = song.duration {
                    self.timerTimeInterval = duration / Double(self.state.photoURLs.value.count)
                }
                self.state.selectedSong.send(song)
                self.state.isSongPlaying.send(true)
            case .failure(let error):
                MSLogger.make(category: .rewindJourney).error("\(error)")
            }
        }
    }
    
    func fetchAlbumCover(from url: URL?) {
        guard let url = url else { return }
        
        Task(priority: .background) {
            let imageData = await self.songRepository.fetchAlbumCoverImage(from: url)
            self.state.albumCoverImageData.send(imageData)
        }
    }
    
}

// MARK: - Functions: Timer

private extension RewindJourneyViewModel {
    
    func startTimer() {
        self.timer = Timer.publish(every: self.timerTimeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                self?.state.timerDidEnded.send()
            }
    }

    func stopTimer() {
        self.timer?.cancel()
    }
    
}
