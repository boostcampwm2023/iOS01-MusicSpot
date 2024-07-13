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

// MARK: - AppUserUseCase

public final class AppUserUseCase: UserUseCase {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    // MARK: Public

    // MARK: - Functions

    public var currentUserID: String {
        userState.currentUserID
    }


    @discardableResult
    public func registerNewUser() async throws(UserError) -> String { // swiftlint:disable:this all
        // 사용중인 유저 존재 여부 확인
        guard !userState.isUserActivated else {
            throw .userAlreadyExists
        }

        // 새로운 유저 생성
        let newUserID = UUID().uuidString

        do {
            // 1. UserDefaults에 등록 (Repository)
            try userRepository.activate(newUserID: newUserID)

            // 2. AppState에 등록 (SSOT)
            userState.authState = .localAuthenticated
        } catch {
            throw .repositoryError(error)
        }

        return newUserID
    }

    // TODO: 서버 구성하며 로그인 기능 구현
    public func authenticate() async throws(UserError) -> User { // swiftlint:disable:this all
        throw .userUpdateFailed
    }

    public func disableUser() throws(UserError) { // swiftlint:disable:this all
        guard userState.isUserActivated else {
            throw .userNotFound
        }

        userState.authState = .disabled
    }

    // MARK: Private

    // MARK: - Properties

    private var userState: UserState = StateContainer.default.userState
    private let userRepository: UserRepository
}

// MARK: - Privates

extension AppUserUseCase {
    // TODO: 로컬 User 데이터와 서버 데이터의 일치성 검사 구현
    private func validateUser(_: User) -> Bool {
        true
    }
}
