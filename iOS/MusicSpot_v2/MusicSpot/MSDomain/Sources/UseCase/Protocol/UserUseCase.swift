//
//  UserUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation

import Entity

public protocol UserUseCase {
    /// 현재 사용하는 User의 `id` 값
    var currentUserID: UUID { get }

    /// 새로운 User를 등록합니다. \
    /// 단, 여기서는 소셜 기능에 진입하기 이전에 **로컬 기능만을 사용**할 때 필요한 정보만을 생성합니다.
    /// - Returns: 생성된 User의 `id`
    func registerNewUser() async throws -> UUID

    /// 현재 사용중인 User 정보를 비활성화합니다. \
    /// 소셜 기능을 사용하지 않는 경우 (로컬 기능만을 사용하는 경우), 해당 계정은 복구할 수 없습니다. \
    /// 소셜 등록을 완료했다면, 이후에 로그인을 통해 데이터를 복원할 수 있습니다.
    func disableUser()
}
