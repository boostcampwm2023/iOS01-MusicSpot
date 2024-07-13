//
//  MockRouter.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation
@testable import MSNetworking

struct MockRouter: Router {
    var baseURL: String {
        "https://www.naver.com"
    }

    var pathURL: String?

    var method: HTTPMethod {
        .get
    }

    var body: HTTPBody?

    var headers: HTTPHeaders?

    var queries: [URLQueryItem]?
}
