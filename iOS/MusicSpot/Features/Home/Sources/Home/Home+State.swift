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
import SSOT

public struct Home {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init() { }

    // MARK: Internal

    // MARK: - Properties

    @State var locationManager = MSLocationManager()
    @State var isUsingStandardMap = true
    @State var isFollowingHead = false
    @Namespace var mapScope

    @State var isPresentingSheet = true
    @State var sheetHeight: CGFloat = .zero

    @Environment(\.states) var states: StateContainer

    var selectedMapStyle: MapStyle {
        isUsingStandardMap
            ? .standard(elevation: .realistic)
            : .hybrid(elevation: .realistic)
    }

}
