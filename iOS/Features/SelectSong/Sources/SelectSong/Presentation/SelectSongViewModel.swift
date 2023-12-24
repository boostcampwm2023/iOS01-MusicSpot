//
//  SelectSongViewModel.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.03.
//

import Combine
import Foundation

import MediaPlayer
import MSData
import MSDomain
import MSLogger
import MusicKit

public final class SelectSongViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case searchTextFieldDidUpdate(String)
    }
    
    public struct State {
        var songs = CurrentValueSubject<[Song], Never>([])
        var isLoading = CurrentValueSubject<Bool, Never>(false)
        
        let lastCoordinate: Coordinate
    }
    
    // MARK: - Properties
    
    private let repository: SongRepository
    
    public var state: State
    
    let lastCoordinate: Coordinate
    
    // MARK: - Initializer
    
    public init(lastCoordinate: Coordinate,
                repository: SongRepository) {
        self.repository = repository
        self.state = State(lastCoordinate: lastCoordinate)
        self.lastCoordinate = lastCoordinate
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let status = await MusicAuthorization.request()
                #if DEBUG
                MSLogger.make(category: .saveJourney).info("음악 권한 상태: \(status)")
                #endif
                
                if #available(iOS 16.0, *) {
                    Task {
                        self.state.isLoading.send(true)
                        defer { self.state.isLoading.send(false) }
                        
                        let songs = await self.fetchSongByRank()
                        self.state.songs.send(songs)
                    }
                }
            }
        case .searchTextFieldDidUpdate(let text):
            if #available(iOS 16.0, *), text.isEmpty {
                Task {
                    let songs = await self.fetchSongByRank()
                    self.state.songs.send(songs)
                }
                return
            }
            
            Task {
                let songs = await self.fetchSong(byTitle: text)
                self.state.songs.send(songs)
            }
        }
    }
    
}

// MARK: - Private Functions

private extension SelectSongViewModel {
    
    func fetchSong(byTitle title: String) async -> [Song] {
        self.state.isLoading.send(true)
        defer { self.state.isLoading.send(false) }
        
        let result = await self.repository.fetchSongList(with: title)
        switch result {
        case .success(let songCollection):
            return songCollection.map { $0 }
        case .failure(let error):
            MSLogger.make(category: .selectSong).error("\(error)")
            return []
        }
    }
    
    @available(iOS 16.0, *)
    func fetchSongByRank() async -> [Song] {
        let result = await self.repository.fetchSongListByRank()
        switch result {
        case .success(let chart):
            return chart.map { $0 }
        case .failure(let error):
            MSLogger.make(category: .selectSong).error("\(error)")
            return []
        }
    }
    
}
