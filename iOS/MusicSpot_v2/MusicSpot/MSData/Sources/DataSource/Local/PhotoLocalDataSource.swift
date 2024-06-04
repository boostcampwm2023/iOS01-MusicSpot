//
//  PhotoLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
final class PhotoLocalDataSource: EntityConvertible {
    typealias Entity = URL

    // MARK: - Relationships

    var spot: SpotLocalDataSource?

    // MARK: - Properties

    var url: URL

    // MARK: - Initializer

    init(url: URL) {
        self.url = url
    }

    // MARK: - Entity Convertible

    public init(from entity: URL) {
        self.url = entity
    }

    public func toEntity() -> URL {
        return self.url
    }
}
