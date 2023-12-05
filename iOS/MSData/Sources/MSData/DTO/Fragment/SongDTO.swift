//
//  SongDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct SongDTO: Codable, Identifiable {
    
    public let id: UInt32
    public let title: String
    public let artist: String
    public let artwork: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case artist = "artistName"
        case artwork
    }
    
}

// MARK: - Artwork

extension SongDTO {
    
    public struct ArtworkDTO: Codable {
        
        public let width: Double
        public let height: Double
        public let url: URL
        public let backgroundColor: String
        public let textColor1: String
        public let textColor2: String
        public let textColor3: String
        public let textColor4: String
        
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
    
}
