//
//  MSImageFetcher+UIImageView.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

import MSImageFetcher

extension UIImageView: MSImageFetcherCompatible { }

extension MSImageFetcherWrapper where Base: UIImageView {
    
    public func hey() {
        print("Hey!")
    }
    
}
