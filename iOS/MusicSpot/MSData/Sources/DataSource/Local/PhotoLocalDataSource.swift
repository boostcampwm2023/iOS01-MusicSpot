//
//  PhotoLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
public final class PhotoLocalDataSource: EntityConvertible {
    public typealias Entity = URL

    // MARK: - Relationships

    public var spot: SpotLocalDataSource?

    // MARK: - Properties

    public var url: URL

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

    public func isEqual(to entity: URL) -> Bool {
        return self.url == entity
    }
}
