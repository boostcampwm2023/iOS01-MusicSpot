//
//  Home+State.swift
//  Home
//
//  Created by 이창준 on 4/18/24.
//

import CoreLocation
import MapKit
import SwiftUI

import MSLocationManager

public struct Home {
    
    // MARK: - Properties
    
    @State var locationManager = MSLocationManager()
    @State var isUsingStandardMap: Bool = true
    var selectedMapStyle: MapStyle {
        return self.isUsingStandardMap
        ? .standard(elevation: .realistic)
        : .hybrid(elevation: .realistic)
    }
    @State var isFollowingHead: Bool = false
    @Namespace var mapScope
    
    @State var isPresentingSheet: Bool = true
    @State var sheetHeight: CGFloat = .zero
    
    // MARK: - Initializer
    
    public init() { }
    
}
