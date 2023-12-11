//
//  RewindJourneyViewModel.swift
//  RewindJourney
//
//  Created by 전민건 on 11/30/23.
//

import Combine
import Foundation
import MusicKit

import MSData
import MSDomain
import MSExtension
import MSImageFetcher
import MSLogger

public final class RewindJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case startAutoPlay
        case stopAutoPlay
    }
    
    public struct State {
        // Passthrough
        let timerPublisher = PassthroughSubject<Void, Never>()
        
        // CurrentValue
        public let photoURLs: CurrentValueSubject<[URL], Never>
        public let prefetchedMusic: CurrentValueSubject<Music, Never>
        public let selectedSong = CurrentValueSubject<Song?, Never>(nil)
    }
    
    // MARK: - Properties
    
    private let spotRepository: SpotRepository
    private let songRepository: SongRepository
    
    public var state: State
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Properties: Timer
    
    private let timerTimeInterval: Double = 4.0
    private var timer: AnyCancellable?
    
    // MARK: - Initializer
    
    public init(photoURLs: [URL],
                music: Music,
                spotRepository: SpotRepository,
                songRepository: SongRepository) {
        self.spotRepository = spotRepository
        self.songRepository = songRepository
        self.state = State(photoURLs: CurrentValueSubject<[URL], Never>(photoURLs),
                           prefetchedMusic: CurrentValueSubject<Music, Never>(music))
    }
    
}

// MARK: - Interface: Actions

extension RewindJourneyViewModel {
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let photoURLs = self.state.photoURLs.value
                
                for photoURL in photoURLs {
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            await MSImageFetcher.shared.fetchImage(from: photoURL, forKey: photoURL.paath())
                        }
                    }
                }
            }
            let songID = self.state.prefetchedMusic.value.id
            self.fetchMusic(byID: songID)
        case .startAutoPlay:
            self.startTimer()
        case .stopAutoPlay:
            self.stopTimer()
        }
    }

}

// MARK: - Functions: Music

private extension RewindJourneyViewModel {
    
    func fetchMusic(byID id: String) {
        Task {
            let result = await self.songRepository.fetchSong(withID: id)
            switch result {
            case .success(let song):
                #if DEBUG
                MSLogger.make(category: .rewindJourney).debug("음악을 찾았습니다: \(song)")
                #endif
                self.state.selectedSong.send(song)
            case .failure(let error):
                MSLogger.make(category: .rewindJourney).error("\(error)")
            }
        }
    }
    
}

// MARK: - Functions: Timer

private extension RewindJourneyViewModel {
    
    func startTimer() {
        self.timer = Timer.publish(every: self.timerTimeInterval, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                self?.state.timerPublisher.send()
            }
    }

    func stopTimer() {
        self.timer?.cancel()
    }
    
}
