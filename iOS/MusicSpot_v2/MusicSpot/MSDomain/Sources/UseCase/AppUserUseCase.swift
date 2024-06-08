//
//  AppUserUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation

public final class AppUserUseCase: UserUseCase {
    public var currentUserID: UUID {
        UUID()
    }

    public func registerNewUser() async throws -> UUID {
        UUID()
    }

    public func disableUser() { }
}
