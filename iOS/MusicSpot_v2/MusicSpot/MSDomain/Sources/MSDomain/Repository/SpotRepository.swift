//
//  SpotRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

import Entity

public protocol SpotRepository {
    
    func fetchRecordingSpots() async -> Result<[Spot], Error>
    func upload(spot: RequestableSpot) async -> Result<Spot, Error>
    @discardableResult
    func fetchSpotPhoto(from photoURL: URL) async -> Data?
    
}
