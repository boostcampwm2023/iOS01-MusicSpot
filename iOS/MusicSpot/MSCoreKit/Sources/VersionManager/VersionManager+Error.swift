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
        case emptyResults
        case unknownAppVersion

        public var errorDescription: String? {
            switch self {
            case .invalidURL(let url):
                "올바르지 않은 URL: \(url)"
            case .emptyResults:
                "앱스토어에서 앱 정보를 불러오지 못했습니다."
            case .unknownAppVersion:
                "앱 버전 정보를 읽을 수 없습니다."
            }
        }
    }
}
