//
//  UserRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

import Entity

public protocol UserRepository {
    /// 해당 유저를 활성화 합니다. 비로그인 유저의 경우 유저를 생성하고, 로그인 유저의 경우 회원 가입을 진행하거나 로그인을 진행합니다.
    /// - Parameters:
    ///     - newUserID: 활성화 할 유저가 사용할 `userID`
    /// - Returns: 활성화 된 유저에 대한 정보를 담은 인스턴스
    /// > Note:
    /// > 로그인 유저의 경우 플로우 파악이 아직 되지 않았습니다. 이후에 변경될 수 있습니다.
    @discardableResult
    func activate(newUserID: String) throws -> User

    /// 현재 활성화되어 있는 유저를 비활성화합니다. 비로그인 유저의 경우 유저를 삭제하고, 데이터를 전부 지웁니다.
    /// 로그인 유저의 경우, 로그아웃을 진행하고 마찬가지로 로컬 데이터는 전부 지웁니다.
    /// - Parameters:
    ///     - userID: 비활성화 할 유저의 `userID`
    func deactivate(userID: String) throws
}
