//
//  Artwork.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct AlbumCover {
    
    // MARK: - Properties
    
    public let width: Int
    public let height: Int
    public let url: URL?
    public let backgroundColor: String?
    
    // MARK: - Initializer
    
    public init(width: Int,
                height: Int,
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
