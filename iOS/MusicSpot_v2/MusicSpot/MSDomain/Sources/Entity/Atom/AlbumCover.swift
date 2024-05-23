//
//  Artwork.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct AlbumCover {
    
    // MARK: - Properties
    
    public let width: UInt32
    public let height: UInt32
    public let url: URL?
    public let backgroundColor: String?
    
    // MARK: - Initializer
    
    public init(width: UInt32,
                height: UInt32,
                url: URL?,
                backgroundColor: String?) {
        self.width = width
        self.height = height
        self.url = url
        self.backgroundColor = backgroundColor
    }
    
}

// MARK: - Hashable

extension AlbumCover: Hashable { }
