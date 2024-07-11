//
//  MusicLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import SwiftData

import Entity

@Model
public final class MusicLocalDataSource: EntityConvertible {
    public typealias Entity = Music

    // MARK: - Relationships

    public var journey: JourneyLocalDataSource?

    // MARK: - Properties

    public let musicID: String
    public var title: String
    public var artist: String?
    public var albumCover: AlbumCover?

    // MARK: - Initializer

    init(musicID: String, title: String) {
        self.musicID = musicID
        self.title = title
    }

    // MARK: - Entity Convertible

    public init(from entity: Music) {
        self.musicID = entity.id
        self.title = entity.title
        self.artist = entity.artist
        self.albumCover = entity.albumCover
    }

    public func toEntity() -> Music {
        return Music(
            id: self.musicID,
            title: self.title,
            artist: self.artist,
            albumCover: self.albumCover
        )
    }

    public func isEqual(to entity: Music) -> Bool {
        return self.musicID == entity.id
    }
}
