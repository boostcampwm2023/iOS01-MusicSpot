//
//  SaveJourneySection.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import UIKit

import MSDomain

// MARK: - Section

enum SaveJourneySection: Hashable {
    case music
    case spot
    case empty
    
    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .music:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
        case .spot:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                          heightDimension: .fractionalWidth(0.5))
        case .empty:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
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
        case .empty:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalWidth(1.0))
        }
    }
    
}

// MARK: - Item

enum SaveJourneyItem: Hashable {
    
    case music(Music)
    case spot(Spot)
    case empty
    
}
