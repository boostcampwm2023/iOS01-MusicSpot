//
//  HTTPBody.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct HTTPBody {
    
    // MARK: - Properties
    
    var content: Encodable?
    
    // MARK: - Initializer
    
    public init(content: Encodable? = nil) {
        self.content = content
    }
    
    // MARK: - Functions
    
    func makeData(encoder: JSONEncoder) -> Data? {
        guard let content = self.content,
              let data = try? encoder.encode(content) else {
            return nil
        }
        
        return data
    }
    
}
