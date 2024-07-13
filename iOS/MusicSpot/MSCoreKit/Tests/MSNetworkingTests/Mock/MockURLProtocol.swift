//
//  MockURLProtocol.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.11.27.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    static var delaySimulation: TimeInterval = 0
    static var requestObserver: ((URLRequest) -> Void)?

    static func simulateDelay(_ delay: TimeInterval) {
        delaySimulation = delay
    }

    static func observeRequests(_ observer: @escaping (URLRequest) -> Void) {
        requestObserver = observer
    }

    override class func canInit(with request: URLRequest) -> Bool {
        MockURLProtocol.requestObserver?(request)
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        DispatchQueue.global().asyncAfter(deadline: .now() + MockURLProtocol.delaySimulation) {
            guard let handler = MockURLProtocol.requestHandler else {
                assertionFailure("Received unexpected request with no handler set")
                return
            }

            do {
                let (response, data) = try handler(self.request)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            } catch {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() { }

}
