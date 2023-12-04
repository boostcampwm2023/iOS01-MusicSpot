//
//  User.swift
//  NavigateMap
//
//  Created by 윤동주 on 12/3/23.
//

import Foundation

public struct User {
    var email: String
    var journeys: [Journey]
    public var isRecording: Bool
    var coordinate: Coordinate
}
