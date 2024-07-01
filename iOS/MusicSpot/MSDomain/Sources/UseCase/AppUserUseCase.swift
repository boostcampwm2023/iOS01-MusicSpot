//
//  AppUserUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation
import SwiftUI

import Entity
import MSError
import Repository
import SSOT

public final class AppUserUseCase: UserUseCase {
    // MARK: - Properties

    private var userState: UserState = StateContainer.default.userState

    private let userRepository: UserRepository

    // MARK: - Initializer

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    // MARK: - Functions

    public var currentUserID: String {
        return self.userState.currentUserID
    }

    @discardableResult
    public func registerNewUser() async throws(UserError) -> String {
        // 사용중인 유저 존재 여부 확인
        guard !self.userState.isUserLoggedIn else {
            throw .userAlreadyExists
        }

        // 새로운 유저 생성
        let newUserID = UUID().uuidString

        // AppState 및 UserDefaults에 등록
        self.userState.state = .localAuthenticated

        return newUserID
    }

    // TODO: 서버 구성하며 로그인 기능 구현
    public func authenticate() async throws(UserError) -> User {
        throw .userUpdateFailed
    }

    public func disableUser() throws(UserError) {
        guard self.userState.isUserLoggedIn else {
            throw .userNotFound
        }

        self.userState.state = .disabled
    }
}

// MARK: - Privates

private extension AppUserUseCase {
    // TODO: 로컬 User 데이터와 서버 데이터의 일치성 검사 구현
    func validateUser(_ user: User) -> Bool {
        return true
    }
}