//
//  Journey.swift
//  SaveJourney
//
//  Created by 이창준 on 11/23/23.
//

import Foundation

struct Journey: Hashable {
    
    let title: String
    let date: Date
    let spots: [Spot]
    let song: Song
    
}
