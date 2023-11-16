//
//  PersonDTO.swift
//  
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct PersonDTO {
    let personIdentifier: UUID
    let nickname: String
    let journals: [JournalDTO]
    let email: String
}
