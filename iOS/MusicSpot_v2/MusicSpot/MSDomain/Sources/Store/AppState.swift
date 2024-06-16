//
//  AppState.swift
//  Store
//
//  Created by 이창준 on 6/13/24.
//

import SwiftUI

import Entity

// MARK: - EnvironmentValues

extension EnvironmentValues {
    @Entry
    public var appState = AppState()
}

// MARK: - App State

public struct AppState {
    public var isTraveling: Bool = false
}

// MARK: - Equatable

extension AppState: Equatable {
}
