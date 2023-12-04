//
//  DTO+Mapping.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.03.
//

import Foundation
import MusicKit

extension Song {
    
    init(dto: MusicKit.Song) {
        self.title = dto.title
        self.artist = dto.artistName
        self.albumArtURL = dto.artwork?.url(width: 52, height: 52)
    }
    
}
