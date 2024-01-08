//
//  MusicSpotLiveActivity.swift
//  LiveActivity
//
//  Created by 이창준 on 2024.01.07.
//

import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct MusicSpotLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RecordingJourneyAttributes.self) { context in
            VStack {
                Text("Hello \(context.state.travelingDistance)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.travelingDistance)")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.travelingDistance)")
            } minimal: {
                Text("\(context.state.travelingDistance)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
}

extension RecordingJourneyAttributes {
    
    // Preview
    fileprivate static var preview: RecordingJourneyAttributes {
        RecordingJourneyAttributes()
    }
    
}

extension RecordingJourneyAttributes.JourneyStatus {
    
    fileprivate static var smiley: RecordingJourneyAttributes.JourneyStatus {
        RecordingJourneyAttributes.JourneyStatus(travelingDistance: 50.0,
                                                 numberOfSpots: 3)
    }
    
    fileprivate static var starEyes: RecordingJourneyAttributes.JourneyStatus {
        RecordingJourneyAttributes.JourneyStatus(travelingDistance: 50.0,
                                                 numberOfSpots: 5)
    }
    
}
