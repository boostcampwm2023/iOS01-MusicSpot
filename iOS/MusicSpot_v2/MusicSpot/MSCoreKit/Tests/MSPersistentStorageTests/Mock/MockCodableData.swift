//
//  MockCodableData.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

struct MockCodableData: Codable, Equatable {
    
    let id: UUID
    let title: String
    let content: String
    
    init(id: UUID = UUID(),
         title: String,
         content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
    
}
