//
//  PhotoLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class PhotoLocalDataSource {
    
    // MARK: - Relationships
    
    var spot: SpotLocalDataSource?
    
    // MARK: - Properties
    
    var url: URL
    
    // MARK: - Initializer
    
    init(url: URL) {
        self.url = url
    }
    
}
