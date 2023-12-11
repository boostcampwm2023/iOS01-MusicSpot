//
//  SongRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.03.
//

import Foundation
import MusicKit

import MSLogger
import MSNetworking

public protocol SongRepository {
    
    func fetchSong(withID id: String) async -> Result<Song, Error>
    func fetchSongList(with term: String) async -> Result<MusicItemCollection<Song>, Error>
    @available(iOS 16.0, *)
    func fetchSongListByRank() async -> Result<MusicItemCollection<Song>, Error>
    
}

public struct SongRepositoryImplementation: SongRepository {
    
    // MARK: - Properties
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    public func fetchSong(withID id: String) async -> Result<Song, Error> {
        let musicItemID = MusicItemID(id)
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: musicItemID)
        
        do {
            let response = try await request.response()
            guard let song = response.items.first else {
                MSLogger.make(category: .music).error("주어진 ID에 맞는 음악를 찾을 수 없습니다.")
                return .failure(RepositoryError.emptyResponse)
            }
            return .success(song)
        } catch {
            return .failure(error)
        }
    }
    
    public func fetchSongList(with term: String) async -> Result<MusicItemCollection<Song>, Error> {
        #if MOCK
        guard let jsonURL = Bundle.module.url(forResource: "MockSong", withExtension: "json") else {
            return .failure(MSNetworkError.invalidRouter)
        }
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(MusicCatalogSearchResponse.self, from: jsonData) {
                return .success(result.songs)
            }
        } catch {
            return .failure(error)
        }
        #else
        var searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self])
        searchRequest.limit = 10
        if #available(iOS 16.0, *) {
            searchRequest.includeTopResults = true
        }
        do {
            let searchResponse = try await searchRequest.response()
            return .success(searchResponse.songs)
        } catch {
            return .failure(error)
        }
        #endif
    }
    
    @available(iOS 16.0, *)
    public func fetchSongListByRank() async -> Result<MusicItemCollection<Song>, Error> {
        let request = MusicCatalogChartsRequest(kinds: [.cityTop], types: [Song.self])
        do {
            let searchResponse = try await request.response()
            return .success(searchResponse.songCharts.first!.items)
        } catch {
            return .failure(error)
        }
    }
    
}
