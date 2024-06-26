//
//  MusicRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation
import MusicKit

public protocol MusicRepository {
    func searchMusic(term: String) -> MusicItemCollection<Song>
    func fetchTopRanking(_ genre: Genre) -> MusicItemCollection<Song>
    func fetchAlbumCover(of album: Album) async throws -> Data
    func fetchAlbumCover(_ url: URL) async throws -> Data
}
