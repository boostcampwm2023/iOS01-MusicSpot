//
//  URL+.swift
//  MSFoundation
//
//  Created by 이창준 on 2023.12.08.
//

import Foundation

extension URL {
    /// `if #available` 그만 쓰자 패애애쓰
    public func paath(percentEncoded: Bool = true) -> String {
        if #available(iOS 16.0, *) {
            self.path(percentEncoded: percentEncoded)
        } else {
            path
        }
    }
}
