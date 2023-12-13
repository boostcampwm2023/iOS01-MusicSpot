//
//  RecordJourneyViewModel.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Combine
import CoreLocation
import Foundation

import MSData
import MSDomain
import MSLogger

public final class RecordJourneyViewModel: MapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case locationDidUpdated(CLLocationCoordinate2D)
        case locationsShouldRecorded([CLLocationCoordinate2D])
        case recordingDidCancelled
        case fiveLocationsDidRecorded(CLLocationCoordinate2D)
    }
    
    public struct State {
        // CurrentValue
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var recordingJourney: CurrentValueSubject<RecordingJourney, Never>
        public var recordedCoordinates = CurrentValueSubject<[CLLocationCoordinate2D], Never>([])
        public var filteredCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    }
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private var journeyRepository: JourneyRepository
    
    public var state: State
    
    // MARK: - Initializer
    
    public init(startedJourney: RecordingJourney,
                userRepository: UserRepository,
                journeyRepository: JourneyRepository) {
        self.userRepository = userRepository
        self.journeyRepository = journeyRepository
        self.state = State(recordingJourney: CurrentValueSubject<RecordingJourney, Never>(startedJourney))
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            #if DEBUG
            MSLogger.make(category: .home).debug("View Did load.")
            #endif
            
        /// 이전 currentCoordinate를 previousCoordinate에, 저장할 현재 위치를 currentCoordinate에 update
        case .locationDidUpdated(let coordinate):
            let previousCoordinate = self.state.currentCoordinate.value
            self.state.previousCoordinate.send(previousCoordinate)
            self.state.currentCoordinate.send(coordinate)
            
        /// 저장하고 자 하는 위치 데이터를 서버에 전송
        case .locationsShouldRecorded(let coordinates):
            Task {
                let recordingJourney = self.state.recordingJourney.value
                let coordinates = coordinates.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
                let result = await self.journeyRepository.recordJourney(journeyID: recordingJourney.id,
                                                                        at: coordinates)
                switch result {
                case .success(let recordingJourney):
                    self.state.recordingJourney.send(recordingJourney)
                    self.state.filteredCoordinate.send(nil)
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        /// 기록 중에 여정 기록을 취소
        case .recordingDidCancelled:
            Task {
                guard let userID = self.userRepository.fetchUUID() else { return }
                
                let recordingJourney = self.state.recordingJourney.value
                let result = await self.journeyRepository.deleteJourney(recordingJourney, userID: userID)
                switch result {
                case .success(let cancelledJourney):
                    #if DEBUG
                    MSLogger.make(category: .home).debug("여정이 취소 되었습니다: \(cancelledJourney)")
                    #endif
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        /// 업데이트되는 위치 정보를 받아와 5개가 될 경우 평균값 필터링 후 저장하는 로직
        case .fiveLocationsDidRecorded(let coordinate):
            self.filterLongestCoordinate(coordinate: coordinate)
        }
    }
    
}

private extension RecordJourneyViewModel {
    
    func calculateDistance(from coordinate1: CLLocationCoordinate2D,
                           to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude,
                                   longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude,
                                   longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
    
    func filterLongestCoordinate(coordinate: CLLocationCoordinate2D) {
        if let previousCoordinate = self.state.previousCoordinate.value {
            if calculateDistance(from: previousCoordinate, to: coordinate) <= 5 {
                return
            }
        }
        var recordedCoords = self.state.recordedCoordinates.value
        recordedCoords.append(coordinate)
        self.state.recordedCoordinates.send(recordedCoords)
        
        if self.state.recordedCoordinates.value.count >= 5 {
            let initialCoordinate = recordedCoords.reduce(CLLocationCoordinate2D(latitude: 0,
                                                                                 longitude: 0)) { result, coordinate in
                return CLLocationCoordinate2D(latitude: result.latitude + coordinate.latitude,
                                              longitude: result.longitude + coordinate.longitude)
            }
            let initialLat = initialCoordinate.latitude
            let initialLong = initialCoordinate.longitude
            let averageCoordinate = CLLocationCoordinate2D(latitude: initialLat / Double(recordedCoords.count),
                                                           longitude: initialLong / Double(recordedCoords.count))
            
            // 가장 먼 거리에 있는 Coordinate의 index값을 찾음.
            guard let indexToRemove = recordedCoords.enumerated().max(by: {
                let distance1 = calculateDistance(from: $0.element,
                                                  to: averageCoordinate)
                let distance2 = calculateDistance(from: $1.element,
                                                  to: averageCoordinate)
                return distance1 < distance2
            })?.offset else {
                return
            }
            
            var fourCoordinates = recordedCoords
            fourCoordinates.remove(at: indexToRemove)
            
            let finalCoordinate = fourCoordinates.reduce(CLLocationCoordinate2D(latitude: 0,
                                                                                longitude: 0)) { result, coordinate in
                return CLLocationCoordinate2D(latitude: result.latitude + coordinate.latitude,
                                              longitude: result.longitude + coordinate.longitude)
            }
            let finalLat = finalCoordinate.latitude
            let finalLong = finalCoordinate.longitude
            let finalAverage = CLLocationCoordinate2D(latitude: finalLat / Double(fourCoordinates.count),
                                                      longitude: finalLong / Double(fourCoordinates.count))
            
            self.state.filteredCoordinate.send(finalAverage)
            self.state.recordedCoordinates.send([])
        }
    }
}
