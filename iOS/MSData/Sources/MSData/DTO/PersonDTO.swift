//
//  PersonDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct PersonDTO: Codable, Identifiable {
    
    public let id: UUID
    public let nickname: String
    public let journeys: [JourneyDTO]
    public let email: String
    
}
