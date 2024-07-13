//
//  AppUserRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/11/24.
//

import Foundation

import DataSource
import Entity
import MSError
import MSUserDefaults
import Repository

public final class AppUserRepository: UserRepository {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init() { }

    // MARK: Public

    // MARK: - Functions

    /// 로컬 유저를 생성합니다.
    /// - Returns: 생성된 `User` 정보를 담고 있는 인스턴스
    @discardableResult
    public func activate(newUserID: String) throws -> User {
        let newUser = User(id: newUserID)
        activeUser = UserLocalDataSource(from: newUser)

        guard activeUser != nil else {
            throw UserError.userNotFound
        }

        return newUser
    }

    /// 로컬 유저를 삭제합니다.
    public func deactivate(userID _: String) throws {
        guard activeUser != nil else {
            throw UserError.userNotFound
        }

        activeUser = nil
    }

    // MARK: Private

    // MARK: - Properties

    @UserDefaultsWrapped("activeUser", defaultValue: nil)
    private var activeUser: UserLocalDataSource?

}
