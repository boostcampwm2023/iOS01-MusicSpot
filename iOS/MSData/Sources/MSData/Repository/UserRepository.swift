//
//  UserRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSKeychainStorage
import MSNetworking

public protocol UserRepository {
    
    func createUser() async -> Result<UUID, Error>
    func fetchUUID() throws -> UUID
    
}

public struct UserRepositoryImplementation: UserRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    private let keychain: MSKeychainStorage
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default),
                keychain: MSKeychainStorage = MSKeychainStorage()) {
        self.networking = MSNetworking(session: session)
        self.keychain = keychain
    }
    
    // MARK: - Functions
    
    public func createUser() async -> Result<UUID, Error> {
        guard let userID = try? self.fetchUUID() else {
            return .failure(MSKeychainStorage.KeychainError.transactionError)
        }
        
        let requestDTO = UserRequestDTO(userID: userID)
        let router = UserRouter.newUser(dto: requestDTO)
        
        let result = await self.networking.request(UserResponseDTO.self, router: router)
        switch result {
        case .success(let userResponse):
            return .success(userResponse.userID)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// UUID가 이미 키체인에 등록되어 있다면 가져옵니다.
    /// 그렇지 않다면 새로 생성하고, 키체인에 등록합니다.
    public func fetchUUID() throws -> UUID {
        let account = MSKeychainStorage.Accounts.userID.rawValue
        if let userID = try? self.keychain.get(UUID.self, account: account) {
            return userID
        }
        
        let newUserID = UUID()
        try self.keychain.set(value: newUserID, account: account)
        return newUserID
    }
    
}
