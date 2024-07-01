//
//  AppUserRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/11/24.
//

import Foundation

import Entity
import Repository

public final class AppUserRepository: UserRepository {
    /// 로컬 유저를 생성합니다.
    public func activate() -> User {
        return User(id: UUID().uuidString)
    }
    
    public func deactivate() {
        //
    }
}
