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

    private var userData = UserData()

    /// User의 등록 상태
    public var userState: UserState {
        get { self.userData.state }
        set { self.userData.state = newValue }
    }

    /// 등록되어 사용 중인 User가 있는 지를 확인하는 computed property
    public var isUserLoggedIn: Bool {
        return self.userData.state != .disabled
    }

    /// 등록되어 사용 중인 User의 ID 값을 받아오는 computed property
    public var currentUserID: String {
        return self.userState.userID
    }

    /// 진행중인 여정이 있는 지 여부
    public var isTraveling: Bool = false

    // MARK: - Shared

    public static let `default` = AppState()

    // MARK: - Initializer

    private init() {}
}
