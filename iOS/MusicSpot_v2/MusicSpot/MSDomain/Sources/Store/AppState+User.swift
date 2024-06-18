//
//  AppState+User.swift
//  Store
//
//  Created by 이창준 on 6/17/24.
//

import MSUserDefaults

extension AppState {
    public struct UserData: Equatable {
        /// 등록되어 사용 중인 User의 ID \
        /// UserDefaults를 사용합니다.
        @UserDefaultsWrapped("userID", defaultValue: "")
        private var userID: String

        /// 등록되어 사용 중인 User의 상태
        var state: UserState = .disabled {
            willSet { self.userID = newValue.userID }
        }

        public static func == (lhs: AppState.UserData, rhs: AppState.UserData) -> Bool {
            return lhs.userID == rhs.userID && lhs.state == rhs.state
        }
    }

    public enum UserState: Equatable {
        case disabled
        /// Local UserID를 사용하는 경우
        case enabledFromEarth(String)
        /// Remote UserID를 사용하는 경우
        case enabledFromAlien(String)

        var userID: String {
            switch self {
            case .disabled:
                return ""
            case .enabledFromEarth(let userID), .enabledFromAlien(let userID):
                return userID
            }
        }
    }
}
