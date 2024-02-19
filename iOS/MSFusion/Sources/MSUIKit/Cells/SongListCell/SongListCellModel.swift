//
//  SongListCellModel.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.03.
//

import Foundation

public struct SongListCellModel: Identifiable {
    
    public let id: String
    let title: String
    let artist: String
    let albumArtURL: URL?
    
    public init(id: String,
                title: String,
                artist: String,
                albumArtURL: URL?) {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumArtURL = albumArtURL
    }
    
}
