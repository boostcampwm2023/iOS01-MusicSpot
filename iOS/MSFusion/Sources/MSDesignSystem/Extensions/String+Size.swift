//
//  String+Size.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.21.
//

import UIKit

extension String {
    
    public func size(using font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return size
    }
    
}
