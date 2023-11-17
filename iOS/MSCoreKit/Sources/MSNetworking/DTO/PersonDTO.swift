//
//  PersonDTO.swift
//  
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct PersonDTO: Codable {
    
    let personIdentifier: UUID
    let nickname: String
    let Journeys: [JourneyDTO]
    let email: String
    
}
