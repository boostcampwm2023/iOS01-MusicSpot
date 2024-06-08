//
//  AppSongUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation
import MusicKit

public final class AppSongUseCase: SongUseCase {
    public func searchSongs(by method: SongFetchMethod?) -> MusicItemCollection<Song> {
        return []
    }

    public func fetchAlbumCover(from url: String) async throws -> Data {
        return Data()
    }
}
