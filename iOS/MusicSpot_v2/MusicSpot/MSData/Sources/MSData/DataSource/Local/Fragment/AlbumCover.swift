//
//  AlbumCover.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation

struct AlbumCover {
    
    public let width: UInt8
    public let height: UInt8
    public let url: URL?
    public let backgroundColor: String?
    
}

// MARK: - Equatable

extension AlbumCover: Equatable {
    
    static func == (lhs: AlbumCover, rhs: AlbumCover) -> Bool {
        return lhs.url == rhs.url
    }
    
}
