//
//  AppState+User.swift
//  SSOT
//
//  Created by 이창준 on 6/17/24.
//

import MSExtension
import MSUserDefaults

public struct UserState {
    public enum AuthState: Equatable, Codable {
        /// 비활성화 된 경우
        case disabled
        /// Local UserID를 사용하는 경우
        case localAuthenticated
        /// Remote UserID를 사용하는 경우
        case remoteAuthenticated

        public var isEnabled: Bool {
            return self != .disabled
        }
    }

    /// 등록되어 사용 중인 `User`의 상태
    package var authState: AuthState = .disabled

    /// 등록되어 사용 중인 `User`의 ID
    package var userID: String = ""

    // MARK: - Interface

    /// 등록되어 사용 중인 `User`의 상태를 받아오는 computed property
    public var currentState: AuthState {
        return self.authState
    }

    /// 등록되어 사용 중인 `User`가 있는 지를 확인하는 computed property
    /// - Returns: 1. `AuthState`가 `disabled`가 아니고 2. `userID`가 비어있지 않은 경우 `true`를 반환합니다.
    public var isUserActivated: Bool {
        let isAuthenticated = self.currentState != .disabled
        return isAuthenticated && self.userID.isValid
    }

    /// 등록되어 사용 중인 `User`의 ID 값을 받아오는 computed property
    public var currentUserID: String {
        return self.userID
    }

    // MARK: - Shared

    public static let shared = UserState()
}

// MARK: - Private Extension: String

private extension String {
    /// `UserID`가 유효한 지 확인합니다.
    /// - Returns: 유효하지 않을 경우 `false`, 유효할 경우 `true`
    var isValid: Bool {
        guard self.isNotEmpty else { return false }
        return true
    }
}

// MARK: - Equatable

extension UserState: Equatable {
    public static func == (lhs: UserState, rhs: UserState) -> Bool {
        return lhs.userID == rhs.userID && lhs.authState == rhs.authState
    }
}
