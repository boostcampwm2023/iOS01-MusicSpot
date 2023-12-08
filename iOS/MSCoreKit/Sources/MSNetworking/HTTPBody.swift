//
//  HTTPBody.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

import MSLogger
import UIKit

public struct HTTPBody {
    
    // MARK: - Status
    
    public enum BodyType {
        case normal
        case multipart
    }
    
    // MARK: - Properties
    
    public let type: BodyType
    private let boundary: String?
    var content: Encodable?
    private var allOfMultipartData: [MultipartData]?
    
    // MARK: - Initializer
    
    public init(type: BodyType = .normal,
                boundary: String? = nil,
                content: Encodable? = nil,
                multipartData: [MultipartData]? = nil) {
        self.type = type
        self.boundary = boundary
        self.content = content
        self.allOfMultipartData = multipartData
    }
    
    // MARK: - Functions
    
    func data(encoder: JSONEncoder) -> Data? {
        switch self.type {
        case .normal:
            guard let content,
            let data = try? encoder.encode(content) else {
                MSLogger.make(category: .network).error("HTTP Body 데이터 인코딩에 실패했습니다.")
                return nil
            }
            MSLogger.make(category: .network).debug("변환된 데이터: \(data)")
            return data
            
        case .multipart:
            guard let boundary,
                  let delimiter: Data = "\r\n--\(boundary)\r\n".data(using: .utf8),
                  let finalDelimiter: Data = "\r\n--\(boundary)--\r\n".data(using: .utf8) else {
                MSLogger.make(category: .network).debug("delimiter 생성에 실패하였습니다.")
                return nil
            }
            var data = Data()
            self.allOfMultipartData?.forEach { multipartData in
                data.append(delimiter)
                multipartData.contentInformation().forEach {
                    data.append($0)
                }
            }
            data.append(finalDelimiter)
            return data
        }
    }
    
}
