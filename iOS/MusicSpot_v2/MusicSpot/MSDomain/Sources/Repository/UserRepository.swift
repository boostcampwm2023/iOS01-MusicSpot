//
//  UserRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

public protocol UserRepository {
    func createUser() async -> Result<UUID, Error>
    func storeUUID(_ userID: UUID) throws -> UUID
    func fetchUUID() -> UUID?
}
