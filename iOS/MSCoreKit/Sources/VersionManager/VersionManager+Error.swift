//
//  VersionManager+Error.swift
//  VersionManager
//
//  Created by 이창준 on 2024.02.13.
//

import Foundation

extension VersionManager {
    
    public enum VersionManagerError: LocalizedError {
        case invalidURL(String)
        case unknownAppVersion
        
        public var errorDescription: String? {
            switch self {
            case .invalidURL(let url):
                return "올바르지 않은 URL: \(url)"
            case .unknownAppVersion:
                return "앱 버전 정보를 읽을 수 없습니다."
            }
        }
    }
    
}
