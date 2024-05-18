//
//  MusicLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import SwiftData

@Model
final class MusicLocalDataSource {
    
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
    
}
