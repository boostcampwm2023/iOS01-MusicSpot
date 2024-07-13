//
//  Bundle+.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import Foundation

// MARK: - MSBundle

public class MSBundle {
    public static let bundle = Bundle(for: MSBundle.self)
}

extension Bundle {
    #if SWIFT_PACKAGE
    public static var msDesignSystem: Bundle {
        .module
    }
    #else
    public static var msDesignSystem: Bundle {
        Bundle(for: MSBundle.self)
    }
    #endif
}
