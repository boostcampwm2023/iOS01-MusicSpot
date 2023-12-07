//
//  MultipartData.swift
//  MSCoreKit
//
//  Created by 전민건 on 12/7/23.
//

import Foundation

import MSLogger

public struct MultipartData {
    
    public enum ContentType {
        case string
        case image
    }
    
    // MARK: - Properties
    
    private let type: ContentType
    public let name: String
    public let content: Encodable
    
    // MARK: - Initializer
    
    public init(type: ContentType = .string, name: String, content: Encodable) {
        self.type = type
        self.name = name
        self.content = content
    }
    
    // MARK: - Functions
    
    public func contentInformation() -> [Data] {
        var dataStorage: [Data] = []
        
        switch self.type {
        case .string:
            let dispositionDescript = "Content-Disposition: form-data; name=\"\(self.name)\"\r\n\r\n"
            if let disposition = dispositionDescript.data(using: .utf8),
               let content = self.content as? String,
               let contentData = content.data(using: .utf8) {
                dataStorage.append(disposition)
                dataStorage.append(contentData)
            } else {
                MSLogger.make(category: .network).debug("multipart로 보낼 항목들의 data 반환에 실패하였습니다.")
            }
            
        case .image:
            let dispositionDescript = "Content-Disposition: form-data; name=\"image\"; filename=\"test.png\"\r\n"
            let typeDescript = "Content-Type: image/png\r\n\r\n"
            if let disposition = dispositionDescript.data(using: .utf8),
               let type = typeDescript.data(using: .utf8),
               let contentData = self.content as? Data {
                dataStorage.append(disposition)
                dataStorage.append(type)
                dataStorage.append(contentData)
            } else {
                MSLogger.make(category: .network).debug("multipart로 보낼 항목들의 data 반환에 실패하였습니다.")
            }
        }
        return dataStorage
    }
    
}
