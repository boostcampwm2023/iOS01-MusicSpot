//
//  MSConcurrencyNetworkingTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.05.
//

import XCTest
@testable import MSNetworking

final class MSConcurrencyNetworkingTests: XCTestCase {
    
    // MARK: - Properties
    
    private var networking: MSNetworking!
    
    // MARK: - Setup
    
    override func setUp() {
        URLProtocol.registerClass(MockURLProtocol.self)
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses?.insert(MockURLProtocol.self, at: .zero)
        let session = URLSession(configuration: configuration)
        self.networking = MSNetworking(session: session)
    }
    
    // MARK: - Tests

    func test_MSNetworking_응답코드가_200번대일경우_정상() async throws {
        // Arrange
        let router = MockRouter()
        let response = "Success"
        let data = try JSONEncoder().encode(response)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://api.codesquad.kr/api")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        
        let expectation = XCTestExpectation()
        
        // Act
        let result = await self.networking.request(String.self, router: router)
        
        switch result {
        case .success(let value):
            XCTAssertEqual("Success", value, "응답 값이 일치하지 않습니다.")
            expectation.fulfill()
        case .failure:
            XCTFail("200 번대 status code를 포함한 응답은 성공해야 합니다.")
        }
        
        // Assert
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    func test_MSNetworking_응답코드가_200번대가아닐경우_에러() async {
        // Arrange
        let router = MockRouter()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://api.codesquad.kr/api")!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, Data())
        }
        
        let expectation = XCTestExpectation()
        
        // Act
        let result = await self.networking.request(String.self, router: router)
        
        switch result {
        case .success:
            XCTFail("200 ~ 299 외의 status code를 포함한 응답은 에러를 발생시켜야 합니다.")
        case .failure(let error):
            //swiftlint:disable force_cast
            XCTAssertEqual(error as! MSNetworkError,
                           MSNetworkError.invalidStatusCode(statusCode: 404, description: ""),
                           "404 status code 응답은 invalidStatusCode 에러를 발생시켜야 합니다.")
            expectation.fulfill()
        }
        
        // Assert
        await fulfillment(of: [expectation], timeout: 5.0)
    }

}
