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
    
    private let appleID = "6474530486"
    
    public let appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    public var appStoreURL: URL? {
        let urlString = "itms-apps://itunes.apple.com/app/apple-store/\(self.appleID)"
        return URL(string: urlString)
    }
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    public func appStoreVersion() async -> Result<String, Error> {
        let urlString = "http://itunes.apple.com/lookup?id=\(self.appleID)&country=kr"
        guard let url = URL(string: urlString) else {
            return .failure(VersionManagerError.invalidURL(urlString))
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
            
            guard let results = json?["results"] as? [JSON],
                  let appStoreVersion = results.first?["version"] as? String else {
                return .failure(VersionManagerError.invalidURL(urlString))
            }
            
            return .success(appStoreVersion)
        } catch {
            return .failure(error)
        }
    }
    
    public func checkIfUpdateNeeded() async -> Result<Bool, Error> {
        guard let currentVersion = self.appVersion else {
            return .failure(VersionManagerError.unknownAppVersion)
        }
        
        switch await self.appStoreVersion() {
        case .success(let appStoreVersion):
            let compareResult = currentVersion.compare(appStoreVersion, options: .numeric)
            return compareResult == .orderedAscending ? .success(true) : .success(false)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
