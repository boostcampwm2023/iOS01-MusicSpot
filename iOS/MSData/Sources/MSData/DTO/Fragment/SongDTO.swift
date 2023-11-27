//
//  SongDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct SongDTO: Codable, Identifiable {
    
    public let id: UUID
    let title: String
    let artwork: String
    
}
