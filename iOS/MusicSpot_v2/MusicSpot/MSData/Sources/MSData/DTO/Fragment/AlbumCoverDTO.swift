//
//  AlbumCoverDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct AlbumCoverDTO {
    // MARK: - Properties

    public let width: Int
    public let height: Int
    public let url: URL?
    public let backgroundColor: String?

    // MARK: - Initializer

    public init(width: Int,
                height: Int,
                url: URL?,
                backgroundColor: String?) {
        self.width = width
        self.height = height
        self.url = url
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Codable

extension AlbumCoverDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case backgroundColor = "bgColor"
    }
}

// MARK: - Domain Mapping

import Entity
import MSDomain

extension AlbumCoverDTO {
    public init?(_ domain: AlbumCover?) {
        guard let domain else { return nil }

        self.width = Int(domain.width)
        self.height = Int(domain.height)
        self.url = domain.url
        self.backgroundColor = domain.backgroundColor
    }

    public func toDomain() -> AlbumCover {
        return AlbumCover(width: UInt32(self.width),
                          height: UInt32(self.height),
                          url: self.url,
                          backgroundColor: self.backgroundColor)
    }
}
