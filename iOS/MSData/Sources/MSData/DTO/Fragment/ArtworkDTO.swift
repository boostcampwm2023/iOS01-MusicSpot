//
//  File.swift
//  
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation
    
public struct ArtworkDTO {
    
    // MARK: - Properties
    
    public let width: Double
    public let height: Double
    public let url: URL
    public let backgroundColor: String
    public let textColor1: String
    public let textColor2: String
    public let textColor3: String
    public let textColor4: String
    
    // MARK: - Initializer
    
    public init(width: Double,
                height: Double,
                url: URL,
                backgroundColor: String,
                textColor1: String,
                textColor2: String,
                textColor3: String,
                textColor4: String) {
        self.width = width
        self.height = height
        self.url = url
        self.backgroundColor = backgroundColor
        self.textColor1 = textColor1
        self.textColor2 = textColor2
        self.textColor3 = textColor3
        self.textColor4 = textColor4
    }
    
}

// MARK: - Codable

extension ArtworkDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case backgroundColor = "bgColor"
        case textColor1
        case textColor2
        case textColor3
        case textColor4
    }
    
}

// MARK: - Domain Mapping

import MSDomain

extension ArtworkDTO {
    
    public init(_ domain: Artwork) {
        self.width = domain.width
        self.height = domain.height
        self.url = domain.url
        self.backgroundColor = domain.backgroundColor
        self.textColor1 = domain.textColor1
        self.textColor2 = domain.textColor2
        self.textColor3 = domain.textColor3
        self.textColor4 = domain.textColor4
    }
    
    public func toDomain() -> Artwork {
        return Artwork(width: self.width,
                       height: self.height,
                       url: self.url,
                       backgroundColor: self.backgroundColor,
                       textColor1: self.textColor1,
                       textColor2: self.textColor2,
                       textColor3: self.textColor3,
                       textColor4: self.textColor4)
    }
    
}
