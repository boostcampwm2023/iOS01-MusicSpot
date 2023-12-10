//
//  MSCollectionView.swift
//  JourneyList
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

final class MSCollectionView: UICollectionView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let supplementaryViews = self.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)
        for supplementaryView in supplementaryViews {
            if supplementaryView.frame.contains(point) {
                return nil
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
}
