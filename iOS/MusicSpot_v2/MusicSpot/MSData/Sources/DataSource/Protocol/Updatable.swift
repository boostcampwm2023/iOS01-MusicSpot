//
//  Updatable.swift
//  DataSource
//
//  Created by 이창준 on 6/24/24.
//

import SwiftData

package protocol Updatable: PersistentModel {
    func update(to dataSource: Self)
}

extension Updatable where Self: EntityConvertible {
    package func update(to entity: Entity) {
        self.update(to: Self(from: entity))
    }
}
