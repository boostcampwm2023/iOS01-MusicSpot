//
//  MSCacheableData.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/15/23.
//

import Foundation

public final class MSCacheableData: Codable {
    
    struct Metadata: Hashable, Codable {
        let etag: String
        let lastUsed: Date
    }
    
    // MARK: - Properties
    
    let data: Data
    let metadata: Metadata
    
    // MARK: - Initializer
    
    public init(data: Data, etag: String) {
        self.data = data
        self.metadata = Metadata(etag: etag, lastUsed: .now)
    }
    
}
