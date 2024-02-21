//
//  VersionManagerTests.swift
//  VersionManagerTests
//
//  Created by 이창준 on 2024.02.13.
//

import OSLog
import XCTest

@testable import VersionManager

final class VersionManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var versionManager = VersionManager()
    
    // MARK: - Tests
    
    func test_버전정보휙득_성공() throws {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        if let version = appVersion {
            os_log("앱 버전: \(version)")
        } else {
            XCTFail("Bundle에서 앱 버전을 가져오는데 실패했습니다.")
        }
    }
    
}
