//
//  AppMusicRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/8/24.
//

import Foundation
import MusicKit

import MSImageFetcher
import Repository

public final class AppMusicRepository: MusicRepository {
    private enum Metric {
        static let imageSize: Int = 120
    }

    public func searchMusic(term: String) async throws -> MusicItemCollection<Song> {
        var searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self])
        searchRequest.limit = 10
        searchRequest.includeTopResults = true

        let searchResponse = try await searchRequest.response()
        return searchResponse.songs
    }
    
    public func fetchTopRanking(_ genre: Genre) async throws -> MusicItemCollection<Song> {
        let request = MusicCatalogChartsRequest(kinds: [.cityTop], types: [Song.self])

        let searchResponse = try await request.response()
        return searchResponse.songCharts.first!.items
    }
    
    public func fetchAlbumCover(of album: Album) async throws -> Data {
        guard let imageURL = album.artwork?.url(width: Metric.imageSize, height: Metric.imageSize) else {
            throw ImageFetchError.imageFetchFailed
        }

        return try await self.fetchAlbumCover(imageURL)
    }
    
    public func fetchAlbumCover(_ url: URL) async throws -> Data {
        guard let imageData = await MSImageFetcher.shared.fetchImage(from: url, forKey: url.path()) else {
            throw ImageFetchError.imageFetchFailed
        }
        return imageData
    }
}
