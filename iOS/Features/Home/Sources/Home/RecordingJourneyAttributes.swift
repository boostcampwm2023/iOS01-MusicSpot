//
//  RecordingJourneyAttributes.swift
//  LiveActivityExtension
//
//  Created by 이창준 on 2024.01.07.
//

import ActivityKit

struct RecordingJourneyAttributes: ActivityAttributes {
    
    public typealias JourneyStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var travelingDistance: Double
        var numberOfSpots: Int
    }
    
}
