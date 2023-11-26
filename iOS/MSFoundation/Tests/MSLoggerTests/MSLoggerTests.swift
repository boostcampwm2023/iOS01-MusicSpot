//
//  MSLoggerTests.swift
//  MSFoundation
//
//  Created by 이창준 on 11/14/23.
//

import XCTest
import MSLogger

final class MSLoggerTests: XCTestCase {
    
    func test_Logger객체_잘_생성되는지_성공() {
        //arrange, act
        let logger = MSLogger.make(category: .login)
        
        //assert
        XCTAssertNotNil(logger)
    }
}
