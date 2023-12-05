//
//  SongDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct SongDTO: Identifiable {
    
    // MARK: - Properties
    
    public let id: UInt32
    public let title: String
    public let artist: String
    public let artwork: ArtworkDTO
    
    // MARK: - Initializer
    
    public init(id: UInt32,
                title: String,
                artist: String,
                artwork: ArtworkDTO) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artwork = artwork
    }
    
}

// MARK: - Codable

extension SongDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case artist = "artistName"
        case artwork
    }
    
}
