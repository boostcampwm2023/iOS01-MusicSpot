//
//  Area.swift
//  Entity
//
//  Created by 이창준 on 4/27/24.
//

import Foundation

public struct Area: Equatable, Comparable {
    
    public static func < (lhs: Area, rhs: Area) -> Bool {
        return true
    }
    
}
