//
//  UserLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 7/11/24.
//

import Entity

// MARK: - UserLocalDataSource

public struct UserLocalDataSource: Identifiable, EntityConvertible {
    public typealias Entity = User

    // MARK: - Properties

    public let id: String

    // MARK: - Entity Convertible

    public init(from entity: User) {
        id = entity.id
    }

    public func toEntity() -> User {
        User(id: id)
    }

    public func isEqual(to entity: User) -> Bool {
        id == entity.id
    }
}

// MARK: Codable

extension UserLocalDataSource: Codable { }
