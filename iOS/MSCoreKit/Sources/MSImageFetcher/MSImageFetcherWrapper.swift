//
//  MSImageFetcherWrapper.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.02.
//

import MSCacheStorage

public struct MSImageFetcherWrapper<Base> {
    
    // MARK: - Properties
    
    public let base: Base
    
    // MARK: - Initializer
    
    public init(base: Base) {
        self.base = base
    }
    
}

// MARK: - Compatible

public protocol MSImageFetcherCompatible: AnyObject { }

extension MSImageFetcherCompatible {
    
    // swiftlint: disable identifier_name
    public var ms: MSImageFetcherWrapper<Self> {
        return MSImageFetcherWrapper(base: self)
    }
    // swiftlint: enable identifier_name
    
}
