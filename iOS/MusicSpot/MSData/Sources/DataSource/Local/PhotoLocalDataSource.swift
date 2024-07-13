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

    // MARK: Lifecycle

    // MARK: - Initializer

    init(url: URL) {
        self.url = url
    }

    // MARK: - Entity Convertible

    public init(from entity: URL) {
        url = entity
    }

    // MARK: Public

    public typealias Entity = URL

    // MARK: - Relationships

    public var spot: SpotLocalDataSource?

    // MARK: - Properties

    public var url: URL

    public func toEntity() -> URL {
        url
    }

    public func isEqual(to entity: URL) -> Bool {
        url == entity
    }
}
