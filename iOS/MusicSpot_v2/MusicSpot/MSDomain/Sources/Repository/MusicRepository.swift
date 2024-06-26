//
//  MusicRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation
import MusicKit

import MSError

public protocol MusicRepository {
    func searchMusic(term: String) -> MusicItemCollection<Song>
    func fetchTopRanking(_ genre: Genre) -> MusicItemCollection<Song>
    func fetchAlbumCover(of album: Album) async throws(MusicError) -> Data
    // TODO: SwiftLint Swift 6 적용 후 삭제
    // swiftlint:disable:next identifier_name
    func fetchAlbumCover(_ url: URL) async throws(MusicError) -> Data
}
