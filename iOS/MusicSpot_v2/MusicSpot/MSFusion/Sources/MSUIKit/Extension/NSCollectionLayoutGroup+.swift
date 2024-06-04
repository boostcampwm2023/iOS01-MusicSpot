//
//  NSCollectionLayoutGroup+.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.08.
//

import UIKit

extension NSCollectionLayoutGroup {
    public static func horizontal(layoutSize: NSCollectionLayoutSize,
                                  item: NSCollectionLayoutItem,
                                  count: Int) -> NSCollectionLayoutGroup {
        if #available(iOS 16.0, *) {
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                      repeatingSubitem: item,
                                                      count: count)
        } else {
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                      subitem: item,
                                                      count: count)
        }
    }
}
