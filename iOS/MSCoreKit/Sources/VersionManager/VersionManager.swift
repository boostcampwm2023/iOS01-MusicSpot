//
//  VersionManager.swift
//  VersionManager
//
//  Created by 이창준 on 2024.02.13.
//

import Foundation

import MSLogger

public struct VersionManager {
    typealias JSON = [String: Any]
    
    // MARK: - Properties
    
    private let decoder = JSONDecoder()
    
    private let appleID = "6474530486"
    
    public let appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    public var appStoreURL: URL? {
        let urlString = "itms-apps://itunes.apple.com/app/apple-store/\(self.appleID)"
        return URL(string: urlString)
    }
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    public func fetchAppStoreLookUp() async -> Result<AppStoreLookUp, Error> {
        let urlString = "http://itunes.apple.com/lookup?id=\(self.appleID)&country=kr"
        guard let url = URL(string: urlString) else {
            return .failure(VersionManagerError.invalidURL(urlString))
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let appStoreResponse = try self.decoder.decode(AppStoreResponse.self, from: data)
            guard appStoreResponse.numberOfResults ?? .zero >= 1,
                  let lookUp = appStoreResponse.results.first else {
                throw VersionManagerError.emptyResults
            }
            return .success(lookUp)
        } catch {
            return .failure(error)
        }
    }
    
    /// 앱스토어에서 새로운 버전으로 업데이트할 수 있는 지 확인합니다.
    /// - Returns: **[Tuple]** (`isUpdateNeeded`: Bool, `releaseNote`: String?) \
    /// `isUpdateNeeded`: **Bool** - 새로운 버전이 있다면 `True`, 아니라면 `False` \
    /// `releaseNote`: **String?** - 새로운 버전이 있을 경우, 최신 버전의 릴리즈 노트 *(없을 경우 `nil`을 반환합니다.)*
    public func isUpdateAvailable() async throws -> (isUpdateNeeded: Bool, releaseNote: String?) {
        guard let currentVersion = self.appVersion else {
            throw VersionManagerError.unknownAppVersion
        }
        
        switch await self.fetchAppStoreLookUp() {
        case .success(let appStoreLookUp):
            guard let appStoreVersion = appStoreLookUp.version else {
                throw VersionManagerError.unknownAppVersion
            }
            let compareResult = currentVersion.compare(appStoreVersion, options: .numeric)
            let isUpdateNeeded = compareResult == .orderedAscending
            let releaseNote = isUpdateNeeded ? appStoreLookUp.releaseNote : nil
            return (isUpdateNeeded, releaseNote)
        case .failure(let error):
            throw error
        }
    }
    
}
