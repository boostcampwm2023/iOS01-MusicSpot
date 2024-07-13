//
//  AppMusicRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/8/24.
//

import Foundation
import MusicKit

import MSError
import MSImageFetcher
import Repository

public final class AppMusicRepository: MusicRepository {

    // MARK: Public

    public func searchMusic(term: String) async throws -> MusicItemCollection<Song> {
        var searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self])
        searchRequest.limit = 10
        searchRequest.includeTopResults = true

        let searchResponse = try await searchRequest.response()
        return searchResponse.songs
    }

    public func fetchTopRanking(_: Genre) async throws -> MusicItemCollection<Song> {
        let request = MusicCatalogChartsRequest(kinds: [.cityTop], types: [Song.self])

        let searchResponse = try await request.response()

        guard let musicItems = searchResponse.songCharts.first?.items else {
            throw MusicError.musicChartFetchFailed
        }
        return musicItems
    }

    public func fetchAlbumCover(of album: Album) async throws -> Data {
        guard let imageURL = album.artwork?.url(width: Metric.imageSize, height: Metric.imageSize) else {
            throw ImageFetchError.imageFetchFailed
        }

        return try await fetchAlbumCover(imageURL)
    }

    public func fetchAlbumCover(_ url: URL) async throws -> Data {
        guard let imageData = await MSImageFetcher.shared.fetchImage(from: url, forKey: url.path()) else {
            throw ImageFetchError.imageFetchFailed
        }
        return imageData
    }

    // MARK: Private

    private enum Metric {
        static let imageSize = 120
    }

}
