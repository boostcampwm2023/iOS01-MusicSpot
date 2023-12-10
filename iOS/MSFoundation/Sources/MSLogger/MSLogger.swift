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
            return Logger(subsystem: subsystem, category: category.rawValue)
        } else {
            return Logger(subsystem: "", category: category.rawValue)
        }
    }
    
}
