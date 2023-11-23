//
//  HTTPBody.swift
//
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct HTTPBody {
    
    private let encoder = JSONEncoder()
    var content: Encodable?
    
    func contentToData() -> Data? {
        guard let content, let data = try? encoder.encode(content) else {
            return nil
        }
        return data
    }
    
}
