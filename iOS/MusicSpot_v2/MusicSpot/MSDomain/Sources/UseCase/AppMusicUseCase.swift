//
//  AppMusicUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation
import MusicKit

public final class AppMusicUseCase: MusicUseCase {
    public func searchMusics(by method: MusicFetchMethod?) -> MusicItemCollection<Song> {
        return []
    }

    public func fetchAlbumCover(from url: String) async throws -> Data {
        return Data()
    }
}
