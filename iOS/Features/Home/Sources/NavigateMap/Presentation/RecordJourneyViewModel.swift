//
//  File.swift
//  
//
//  Created by 이창준 on 2023.12.10.
//

import Combine
import CoreLocation
import Foundation

public final class RecordJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    }
    
}
