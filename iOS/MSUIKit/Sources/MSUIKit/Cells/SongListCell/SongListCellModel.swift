//
//  SongListCellModel.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.03.
//

import Foundation

public struct SongListCellModel {
    
    let title: String
    let artist: String
    let albumArtURL: URL?
    
    public init(title: String,
                artist: String,
                albumArtURL: URL?) {
        self.title = title
        self.artist = artist
        self.albumArtURL = albumArtURL
    }
    
}
