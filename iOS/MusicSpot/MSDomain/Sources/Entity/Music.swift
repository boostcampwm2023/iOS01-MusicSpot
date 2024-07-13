//
//  Song.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

// MARK: - Music

public struct Music: Identifiable {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        id: String,
        title: String,
        artist: String?,
        albumCover: AlbumCover?)
    {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
    }

    // MARK: Public

    // MARK: - Properties

    public let id: String
    public let title: String
    public let artist: String?
    public let albumCover: AlbumCover?

}

// MARK: Hashable

extension Music: Hashable { }
