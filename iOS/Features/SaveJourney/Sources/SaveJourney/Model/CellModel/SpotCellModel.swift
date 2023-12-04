//
//  SpotCellModel.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation

public struct SpotCellModel: Hashable {
    
    let location: String
    let date: Date
    let photoURL: URL
    
    public init(location: String,
         date: Date,
         photoURL: URL) {
        self.location = location
        self.date = date
        self.photoURL = photoURL
    }
    
}
