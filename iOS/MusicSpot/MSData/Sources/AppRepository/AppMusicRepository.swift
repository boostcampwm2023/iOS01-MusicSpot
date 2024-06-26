//
//  AppMusicRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/8/24.
//

import Foundation
import MusicKit

import Repository

public final class AppMusicRepository: MusicRepository {
    public func searchMusic(term: String) -> MusicItemCollection<Song> {
        []
    }
    
    public func fetchTopRanking(_ genre: Genre) -> MusicItemCollection<Song> {
        []
    }
    
    public func fetchAlbumCover(of album: Album) async throws -> Data {
        Data()
    }
    
    public func fetchAlbumCover(_ url: URL) async throws -> Data {
        Data()
    }
}
