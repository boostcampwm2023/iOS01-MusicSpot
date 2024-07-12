//
//  UserLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 7/11/24.
//

import Entity

public struct UserLocalDataSource: Identifiable, EntityConvertible {
    public typealias Entity = User

    // MARK: - Properties

    public let id: String

    // MARK: - Entity Convertible

    public init(from entity: User) {
        self.id = entity.id
    }

    public func toEntity() -> User {
        return User(id: self.id)
    }

    public func isEqual(to entity: User) -> Bool {
        return self.id == entity.id
    }
}

extension UserLocalDataSource: Codable { }
