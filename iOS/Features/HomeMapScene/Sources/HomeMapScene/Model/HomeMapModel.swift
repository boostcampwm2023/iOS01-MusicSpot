//
//  HomeMapModel.swift
//
//
//  Created by 윤동주 on 11/26/23.
//

import Foundation

struct Song {
    var id: UUID
    var title: String
    var atrwork: String
}

struct JourneyMetadata {
    var date: Date
}

struct Coordinate {
    var latitude: Double
    var longitude: Double
}

struct Spot {
    var id: UUID
    var coordinate: Coordinate
    var photo: String?
    var w3w: String
}

public struct Journey {
    var id: UUID
    var title: String
    var metadata: JourneyMetadata
    var spots: [Spot]
    var coordinates: [Coordinate]
    var song: Song
    var lineColor: String
    
}

public struct User {
    var email: String
    var journeys: [Journey]
    public var isRecording: Bool
    var coordinate: Coordinate
}
