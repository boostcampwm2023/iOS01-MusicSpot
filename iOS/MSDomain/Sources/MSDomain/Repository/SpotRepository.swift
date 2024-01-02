//
//  SpotRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

public protocol SpotRepository {
    
    func fetchRecordingSpots() async -> Result<[Spot], Error>
    func upload(spot: Spot) async -> Result<Spot, Error>
    
}
