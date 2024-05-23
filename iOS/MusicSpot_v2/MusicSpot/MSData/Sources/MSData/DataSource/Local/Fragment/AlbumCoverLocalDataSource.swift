//
//  AlbumCoverLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/22/24.
//

import Foundation
import SwiftData

import Entity

@Model
final class AlbumCoverLocalDataSource: EntityConvertible {
    typealias Entity = AlbumCover
    
    // MARK: - Properties
    
    var width: UInt32
    var height: UInt32
    var url: URL?
    var backgroundColor: String?
    
    // MARK: - Initializer
    
    init(width: UInt32, height: UInt32, url: URL? = nil, backgroundColor: String? = nil) {
        self.width = width
        self.height = height
        self.url = url
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Entity Convertible
    
    init(from entity: AlbumCover) {
        self.width = entity.width
        self.height = entity.height
        self.url = entity.url
        self.backgroundColor = entity.backgroundColor
    }
    
    func toEntity() -> AlbumCover {
        return AlbumCover(
            width: self.width,
            height: self.height,
            url: self.url,
            backgroundColor: self.backgroundColor
        )
    }
    
}
