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
    private let imageType: String = "jpeg"
    
    // MARK: - Initializer
    
    public init(type: ContentType = .string, name: String, content: Encodable) {
        self.type = type
        self.name = name
        self.content = content
    }
    
    // MARK: - Functions
    
    public func contentInformation(using encoder: JSONEncoder) -> [Data] {
        var dataStorage: [Data] = []
        switch self.type {
        case .string:
            let dispositionDescript = "Content-Disposition: form-data; name=\"\(self.name)\"\r\n\r\n"
            if let disposition = dispositionDescript.data(using: .utf8),
               let contentString = self.convertToString(from: self.content),
               let contentData = contentString.data(using: .utf8) {
                dataStorage.append(disposition)
                dataStorage.append(contentData)
                MSLogger.make(category: .network).debug("\(contentData): multipart로 보낼 항목들이 성공적으로 변환되었습니다.")
            } else {
                MSLogger.make(category: .network).debug("multipart로 보낼 항목들의 data 반환에 실패하였습니다.")
            }
            
        case .image:
            let dispositionDescript = "Content-Disposition: form-data; name=\"image\"; filename=\"test.png\"\r\n"
            let typeDescript = "Content-Type: image/\(self.imageType)\r\n\r\n"
            if let disposition = dispositionDescript.data(using: .utf8),
               let type = typeDescript.data(using: .utf8),
               let contentData = self.content as? Data {
                dataStorage.append(disposition)
                dataStorage.append(type)
                dataStorage.append(contentData)
                MSLogger.make(category: .network).debug("\(contentData): multipart로 보낼 이미지가 성공적으로 변환되었습니다.")
            } else {
                MSLogger.make(category: .network).debug("multipart로 보낼 항목들의 data 반환에 실패하였습니다.")
            }
        }
        return dataStorage
    }
    
    // MARK: - Data Convert
    
    private func convertToString(from content: Encodable) -> String? {
        switch content {
        case is String:
            return content as? String
        case is Date:
            guard let contentDate = content as? Date else { return nil }
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions.insert(.withFractionalSeconds)
            let dateString = dateFormatter.string(from: contentDate)
            return dateString
        default:
            guard let contentData = try? JSONEncoder().encode(content),
                  let contentString = String(data: contentData, encoding: .utf8) else { return nil }
            return contentString
        }
    }
    
}
