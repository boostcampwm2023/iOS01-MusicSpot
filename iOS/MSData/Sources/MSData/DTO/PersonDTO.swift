//
//  PersonDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct PersonDTO: Codable, Identifiable {
    
    public let id: UUID
    let nickname: String
    let journeys: [JourneyDTO]
    let email: String
    
}
