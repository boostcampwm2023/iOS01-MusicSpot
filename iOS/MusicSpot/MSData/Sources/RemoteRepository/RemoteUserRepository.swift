//
//  RemoteUserRepository.swift
//  RemoteRepository
//
//  Created by 이창준 on 7/1/24.
//

import Foundation

import Entity
import Repository

public final class RemoteUserRepository: UserRepository {
    public enum ActivationMethod {
        case signUp
        case login
    }

    /// 로그인 유저를 등록합니다.
    public func activate() -> User {
        return User(id: UUID().uuidString)
    }
    
    public func deactivate() {
        //
    }
}
