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
        var songs = CurrentValueSubject<[Music], Never>([])
    }
    
    // MARK: - Properties
    
    private let repository: SongRepository
    
    public var state = State()
    
    private var musicAuthorizationState: MusicAuthorization.Status?
    
    // MARK: - Initializer
    
    public init(repository: SongRepository) {
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
                        print(songCollection)
//                        let songs = songCollection.map { Music(dto: $0) }
//                        self.state.songs.send(songs)
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
