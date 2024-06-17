//
//  AppState.swift
//  Store
//
//  Created by 이창준 on 6/13/24.
//

import Entity

// MARK: - App State

public struct AppState {
    // MARK: - Properties
    
    /// User의 등록 상태
    public var userData = UserData()

    /// 등록되어 사용 중인 User가 있는 지를 확인하는 computed property
    public var isUserLoggedIn: Bool {
        return self.userData.state != .disabled
    }

    /// 진행중인 여정이 있는 지 여부
    public var isTraveling: Bool = false

    // MARK: - Shared

    public static let `default` = AppState()

    // MARK: - Initializer

    private init() {}
}
