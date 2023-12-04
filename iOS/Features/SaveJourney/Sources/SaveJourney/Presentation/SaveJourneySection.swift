//
//  SaveJourneySection.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import UIKit

// MARK: - Section

enum SaveJourneySection {
    case music
    case spot
    
    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .music:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
        case .spot:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                          heightDimension: .fractionalWidth(0.5))
        }
    }
    
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .music:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .estimated(SaveJourneyMusicCell.estimatedHeight))
        case .spot:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalWidth(0.5))
        }
    }
    
}

// MARK: - Item

enum SaveJourneyItem: Hashable {
    case music(String)
    case spot(Spot)
}
