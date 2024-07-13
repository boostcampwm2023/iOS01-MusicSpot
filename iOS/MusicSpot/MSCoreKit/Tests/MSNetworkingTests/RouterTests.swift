//
//  RouterTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.05.
//

import XCTest
@testable import MSNetworking

final class RouterTests: XCTestCase {

    // MARK: Internal

    // MARK: - Tests

    func test_BaseURL만포함하는_Router_생성_성공() {
        struct SUTRouter: Router {
            var baseURL: String { "https://www.naver.com" }
            var pathURL: String?
            var method: HTTPMethod { .get }
            var body: HTTPBody?
            var headers: HTTPHeaders?
            var queries: [URLQueryItem]?
        }

        let sut = SUTRouter()

        guard let request = sut.makeRequest(encoder: encoder) else {
            XCTFail("URLRequest를 생성하는데 실패했습니다.")
            return
        }

        guard let url = URL(string: "https://www.naver.com") else {
            return
        }
        XCTAssertEqual(
            request,
            URLRequest(url: url),
            "BaseURL만 포함된 Router로 잘못된 URLRequest가 생성되었습니다.")
    }

    func test_PathURL을포함하는_Router_생성_성공() {
        struct SUTRouter: Router {
            var baseURL: String { "https://www.naver.com" }
            var pathURL: String? { "api" }
            var method: HTTPMethod { .get }
            var body: HTTPBody?
            var headers: HTTPHeaders?
            var queries: [URLQueryItem]?
        }

        let sut = SUTRouter()

        guard let request = sut.makeRequest(encoder: encoder) else {
            XCTFail("URLRequest를 생성하는데 실패했습니다.")
            return
        }

        guard let url = URL(string: "https://www.naver.com/api") else {
            return
        }
        let message = """
            BaseURL만 포함된 Router로 잘못된 URLRequest가 생성되었습니다. \
            생성된 URL: \(url)
            """
        XCTAssertEqual(request, URLRequest(url: url), message)
    }

    func test_Body를포함하는_Router_생성_성공() throws {
        struct SUTRouter: Router {
            var baseURL: String { "https://www.naver.com" }
            var pathURL: String? { "api" }
            var method: HTTPMethod { .get }
            var body: HTTPBody? { HTTPBody(content: "Data") }
            var headers: HTTPHeaders?
            var queries: [URLQueryItem]?
        }

        let sut = SUTRouter()

        guard let request = sut.makeRequest(encoder: encoder) else {
            XCTFail("URLRequest를 생성하는데 실패했습니다.")
            return
        }

        guard let url = URL(string: "https://www.naver.com/api") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        let data = try JSONEncoder().encode("Data")
        urlRequest.httpBody = data
        let message = """
            BaseURL만 포함된 Router로 잘못된 URLRequest가 생성되었습니다. \
            생성된 URL: \(url)
            """
        XCTAssertEqual(request.httpBody, urlRequest.httpBody, message)
    }

    func test_Header를포함하는_Router_생성_성공() {
        struct SUTRouter: Router {
            var baseURL: String { "https://www.naver.com" }
            var pathURL: String? { "api" }
            var method: HTTPMethod { .get }
            var body: HTTPBody?
            var headers: HTTPHeaders? { [(key: "boostcamp", value: "WM8")] }
            var queries: [URLQueryItem]?
        }

        let sut = SUTRouter()

        guard let request = sut.makeRequest(encoder: encoder) else {
            XCTFail("URLRequest를 생성하는데 실패했습니다.")
            return
        }

        guard let url = URL(string: "https://www.naver.com/api") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("WM8", forHTTPHeaderField: "boostcamp")
        let message = """
            BaseURL만 포함된 Router로 잘못된 URLRequest가 생성되었습니다. \
            생성된 URL: \(url)
            """
        XCTAssertEqual(request.allHTTPHeaderFields, urlRequest.allHTTPHeaderFields, message)
    }

    func test_Query를포함하는_Router_생성_성공() {
        struct SUTRouter: Router {
            var baseURL: String { "https://www.naver.com" }
            var pathURL: String? { "api" }
            var method: HTTPMethod { .get }
            var body: HTTPBody?
            var headers: HTTPHeaders?
            var queries: [URLQueryItem]? { [URLQueryItem(name: "boostcamp", value: "WM8")] }
        }

        let sut = SUTRouter()

        guard let request = sut.makeRequest(encoder: encoder) else {
            XCTFail("URLRequest를 생성하는데 실패했습니다.")
            return
        }

        guard let url = URL(string: "https://www.naver.com/api?boostcamp=WM8") else {
            return
        }
        let message = """
            BaseURL만 포함된 Router로 잘못된 URLRequest가 생성되었습니다. \
            생성된 URL: \(url)
            """
        XCTAssertEqual(request, URLRequest(url: url), message)
    }

    // MARK: Private

    // MARK: - Properties

    private let encoder = JSONEncoder()

}
