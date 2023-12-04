//
//  SongRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.03.
//

import Foundation
import MusicKit

import MSNetworking

public protocol SongRepository {
    
    func fetchSongList(with term: String) async -> Result<MusicItemCollection<Song>, Error>
    
}

public struct SongRepositoryImplementation: SongRepository {
    
    // MARK: - Properties
    
    // MARK: - Initializer
    
    public init() {
        
    }
    
    // MARK: - Functions
    
    public func fetchSongList(with term: String) async -> Result<MusicItemCollection<Song>, Error> {
        #if DEBUG
        guard let jsonURL = Bundle.module.url(forResource: "MockSong", withExtension: "json") else {
            return .failure((MSNetworkError.invalidRouter))
        }
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(MusicCatalogSearchResponse.self, from: jsonData) {
                return .success(result.songs)
            }
        } catch {
            print(error)
        }
        #else
        var searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self])
        searchRequest.limit = 10
        do {
            let searchResponse = try await searchRequest.response()
            return .success(searchResponse.songs)
        } catch {
            print(error)
        }
        #endif
        
        return .failure(MSNetworkError.unknownResponse)
    }
    
}
