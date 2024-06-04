//
//  MusicLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import SwiftData

import Entity

@Model
final class MusicLocalDataSource: EntityConvertible {
    typealias Entity = Music

    // MARK: - Relationships

    var journey: JourneyLocalDataSource?

    // MARK: - Properties

    var title: String
    var artist: String?
    var albumCover: AlbumCover?

    // MARK: - Initializer

    init(title: String) {
        self.title = title
    }

    // MARK: - Entity Convertible

    public init(from entity: Music) {
        self.title = entity.title
        self.artist = entity.artist
        self.albumCover = entity.albumCover
    }

    public func toEntity() -> Music {
        return Music(
            id: "",
            title: self.title,
            artist: self.artist,
            albumCover: self.albumCover
        )
    }
}
