//
//  Timestamp.swift
//  Entity
//
//  Created by 이창준 on 6/15/24.
//

import Foundation

public struct Timestamp {
    public let start: Date
    public package(set) var end: Date?

    public init(start: Date, end: Date? = nil) {
        self.start = start
        self.end = end
    }
}
