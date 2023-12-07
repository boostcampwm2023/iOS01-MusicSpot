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
import MusicKit

public final class SelectSongViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case searchTextFieldDidUpdate(String)
    }
    
    public struct State {
        var songs = CurrentValueSubject<[Song], Never>([])
        
        let recordingJourney: RecordingJourney
        let lastCoordinate: Coordinate
    }
    
    // MARK: - Properties
    
    private let repository: SongRepository
    
    public var state: State
    
    private var musicAuthorizationState: MusicAuthorization.Status?
    
    // MARK: - Initializer
    
    public init(recordingJourney: RecordingJourney,
                lastCoordinate: Coordinate,
                repository: SongRepository) {
        self.state = State(recordingJourney: recordingJourney,
                           lastCoordinate: lastCoordinate)
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            // TODO: 검색 시 수행하도록 변경
            Task {
                let status = await MusicAuthorization.request()
                self.musicAuthorizationState = status
            }
        case .searchTextFieldDidUpdate(let text):
            switch self.musicAuthorizationState {
            case .authorized:
                Task {
                    let result = await self.repository.fetchSongList(with: text)
                    switch result {
                    case .success(let songCollection):
                        self.state.songs.send(songCollection.map { $0 })
                    case .failure(let error):
                        print(error)
                    }
                }
            default:
                return
            }   
        }
    }
    
}
