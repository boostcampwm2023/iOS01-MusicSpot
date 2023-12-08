//
//  MSCollectionView.swift
//  JourneyList
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

final class MSCollectionView: UICollectionView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Cell
        let cells = self.visibleCells
        for cell in cells where cell.frame.contains(point) {
            return super.hitTest(point, with: event)
        }
        
        return nil
    }
    
}
