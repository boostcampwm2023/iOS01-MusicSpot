//
//  EntityConvertible.swift
//  MSData
//
//  Created by 이창준 on 5/20/24.
//

import Foundation

public protocol EntityConvertible {
    associatedtype Entity

    init(from entity: Entity)
    func toEntity() -> Entity
    func isEqual(to entity: Entity) -> Bool
}
