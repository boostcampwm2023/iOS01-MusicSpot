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

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        type: BodyType = .normal,
        boundary: String? = nil,
        content: Encodable? = nil,
        multipartData: [MultipartData]? = nil)
    {
        self.type = type
        self.boundary = boundary
        self.content = content
        allOfMultipartData = multipartData
    }

    // MARK: Public

    // MARK: - Status

    public enum BodyType {
        case normal
        case multipart
    }

    // MARK: - Properties

    public let type: BodyType

    // MARK: Internal

    var content: Encodable?

    // MARK: - Functions

    func data(encoder: JSONEncoder) -> Data? {
        switch type {
        case .normal:
            guard
                let content,
                let data = try? encoder.encode(content)
            else {
                MSLogger.make(category: .network).error("HTTP Body 데이터 인코딩에 실패했습니다.")
                return nil
            }
            return data

        case .multipart:
            guard
                let boundary,
                let delimiter: Data = "\r\n--\(boundary)\r\n".data(using: .utf8),
                let finalDelimiter: Data = "\r\n--\(boundary)--\r\n".data(using: .utf8)
            else {
                MSLogger.make(category: .network).debug("delimiter 생성에 실패하였습니다.")
                return nil
            }
            var data = Data()
            allOfMultipartData?.forEach { multipartData in
                data.append(delimiter)
                for contentInformation in multipartData.contentInformation(using: encoder) {
                    data.append(contentInformation)
                }
            }
            data.append(finalDelimiter)
            return data
        }
    }

    // MARK: Private

    private let boundary: String?
    private var allOfMultipartData: [MultipartData]?

}
