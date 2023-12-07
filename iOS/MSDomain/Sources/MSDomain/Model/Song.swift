//
//  Song.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct Music: Identifiable {
    
    // MARK: - Properties
    
    public let id: UInt32
    public let title: String
    public let artist: String
    public let artwork: Artwork
    
    // MARK: - Initializer
    
    public init(id: UInt32,
                title: String,
                artist: String,
                artwork: Artwork) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artwork = artwork
    }
    
}

// MARK: - Hashable

extension Music: Hashable { }
