//
//  MSLogger.swift
//  MSFoundation
//
//  Created by 이창준 on 11/14/23.
//

import OSLog

public enum MSLogger {
    public static func make(category: MSLogCategory) -> Logger {
        if let subsystem = Bundle.main.bundleIdentifier {
            Logger(subsystem: subsystem, category: category.rawValue)
        } else {
            Logger(subsystem: "", category: category.rawValue)
        }
    }
}
