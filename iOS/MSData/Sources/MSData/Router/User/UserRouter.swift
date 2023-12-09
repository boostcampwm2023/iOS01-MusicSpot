//
//  UserRouter.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import MSNetworking

public enum UserRouter: Router {
    
    /// 첫 시작 시 유저를 생성합니다.
    case newUser(dto: UserRequestDTO)
    
}
