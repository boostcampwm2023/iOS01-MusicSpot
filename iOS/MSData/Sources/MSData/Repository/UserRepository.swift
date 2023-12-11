//
//  UserRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSKeychainStorage
import MSLogger
import MSNetworking

public protocol UserRepository {
    
    func createUser() async -> Result<UUID, Error>
    func fetchUUID() -> UUID?
    
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
        // Keychain에 UserID가 저장되어 있는 지 확인하고 아니라면 새로 생성
        let userID: UUID
        if let existingUserID = self.fetchUUID() {
            userID = existingUserID
        } else {
            userID = UUID()
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
    public func fetchUUID() -> UUID? {
        let account = MSKeychainStorage.Accounts.userID.rawValue
        guard let userID = try? self.keychain.get(UUID.self, account: account) else {
            MSLogger.make(category: .keychain).error("Keychain에서 UserID를 조회하는 것에 실패했습니다.")
            return nil
        }
        
        #if DEBUG
        MSLogger.make(category: .keychain).debug("Keychain에서 UserID를 조회했습니다: \(userID)")
        #endif
        return userID
    }
    
}
