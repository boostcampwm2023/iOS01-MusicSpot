//
//  AppState.swift
//  SSOT
//
//  Created by 이창준 on 6/13/24.
//

import Entity

// MARK: - App State

public struct AppState {
    // MARK: - Properties

    /// 진행중인 여정이 있는 지 여부
    public var isTraveling = false

    // MARK: - Shared

    public static let shared = AppState()
}
