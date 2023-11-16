//
//  SpotDTO.swift
//  
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct SpotDTO {
    let spotIdentifier: UUID
    let cooredinate: [[Double]]
    let photo: Data?
    let w3w: String
}
