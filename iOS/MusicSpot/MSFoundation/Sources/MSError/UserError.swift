//
//  UserError.swift
//  MSError
//
//  Created by 이창준 on 6/17/24.
//

public enum UserError: Error {
    case userNotFound
    case userAlreadyExists
    case userAlreadyLoggedIn
    case userLogoutFailed
    case userDeleteFailed
    case userUpdateFailed
    case userInfoFetchFailed
    case userTokenFetchFailed
    case repositoryError(Error)
}
