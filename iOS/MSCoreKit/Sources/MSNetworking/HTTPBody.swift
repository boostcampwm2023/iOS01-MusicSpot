//
//  HTTPBody.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct HTTPBody {
    
    // MARK: - Properties
    
    private let encoder = JSONEncoder()
    var content: Encodable?
    
    // MARK: - Initializer
    
    public init(content: Encodable? = nil) {
        self.content = content
    }
    
    // MARK: - Functions
    
    func data() -> Data? {
        guard let content,
              let data = try? self.encoder.encode(content) else {
            return nil
        }
        
        return data
    }
    
}
