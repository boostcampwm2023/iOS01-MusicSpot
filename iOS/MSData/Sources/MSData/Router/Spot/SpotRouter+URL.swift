//
//  SpotRouter+URL.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

import MSNetworking

extension SpotRouter {
    
    public var baseURL: String {
        guard let urlString = self.fetchBaseURLFromPlist(from: Bundle.module) else {
            fatalError("APIInfo.plist 파일을 읽을 수 없습니다.")
        }
        
        return urlString.appending("/spot")
    }
    
    public var pathURL: String? {
        switch self {
        case .upload: return ""
        case .downloadSpot: return "/find"
        }
    }
    
}
