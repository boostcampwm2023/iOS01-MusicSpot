//
//  Timestamp.swift
//  Entity
//
//  Created by 이창준 on 6/15/24.
//

import Foundation

public struct Timestamp {
    public let start: Date
    public let end: Date?

    public init(start: Date, end: Date? = nil) {
        self.start = start
        self.end = end
    }
}

// MARK: - Builders

extension Timestamp {
    public static func startNow() -> Timestamp {
        return Timestamp(start: .now)
    }
}
