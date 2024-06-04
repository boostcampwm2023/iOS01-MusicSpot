//
//  SongDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct SongDTO: Identifiable {
    // MARK: - Properties

    public let id: String
    public let title: String
    public let artist: String
    public let albumCover: AlbumCoverDTO?

    // MARK: - Initializer

    public init(id: String,
                title: String,
                artist: String,
                artwork: AlbumCoverDTO?) {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumCover = artwork
    }
}

// MARK: - Codable

extension SongDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case artist = "artistName"
        case albumCover = "artwork"
    }
}

// MARK: - Domain Mapping

import Entity
import MSDomain

extension SongDTO {
    public init(_ domain: Music) {
        self.id = domain.id
        self.title = domain.title
        self.artist = domain.artist ?? ""
        self.albumCover = AlbumCoverDTO(domain.albumCover)
    }

    public func toDomain() -> Music {
        return Music(id: self.id,
                     title: self.title,
                     artist: self.artist,
                     albumCover: self.albumCover?.toDomain())
    }
}
