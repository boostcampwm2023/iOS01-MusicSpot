//
//  AppState+User.swift
//  SSOT
//
//  Created by 이창준 on 6/17/24.
//

import MSUserDefaults

public struct UserState {
    public enum AuthState: Equatable, Codable {
        case disabled
        /// Local UserID를 사용하는 경우
        case localAuthenticated
        /// Remote UserID를 사용하는 경우
        case remoteAuthenticated

        public var isEnabled: Bool {
            return self != .disabled
        }
    }

    /// 등록되어 사용 중인 User의 상태
    @UserDefaultsWrapped("userState", defaultValue: .disabled)
    public var state: AuthState

    /// 등록되어 사용 중인 User의 ID
    @UserDefaultsWrapped("userID", defaultValue: "")
    private var userID: String

    // MARK: - Interface

    /// 등록되어 사용 중인 User가 있는 지를 확인하는 computed property
    public var isUserLoggedIn: Bool {
        return self.state != .disabled && !self.userID.isEmpty
    }

    /// 등록되어 사용 중인 User의 ID 값을 받아오는 computed property
    public var currentUserID: String {
        return self.userID
    }

    // MARK: - Shared

    public static let shared = UserState()
}

extension UserState: Equatable {
    public static func == (lhs: UserState, rhs: UserState) -> Bool {
        return lhs.userID == rhs.userID && lhs.state == rhs.state
    }
}
