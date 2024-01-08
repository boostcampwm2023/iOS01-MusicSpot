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
        case tenLocationsDidRecorded(CLLocationCoordinate2D)
    }
    
    public struct State {
        // CurrentValue
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var recordingJourney: CurrentValueSubject<RecordingJourney, Never>
        public var recordedCoordinates = CurrentValueSubject<[CLLocationCoordinate2D], Never>([])
        public var filteredCoordinate = PassthroughSubject<CLLocationCoordinate2D?, Never>()
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
            
        /// 저장하고자 하는 위치 데이터를 서버에 전송
        case .locationsShouldRecorded(let coordinates):
            Task {
                let recordingJourney = self.state.recordingJourney.value
                let coordinates = coordinates.map { Coordinate(latitude: $0.latitude,
                                                               longitude: $0.longitude) }
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
                let result = await self.journeyRepository.deleteJourney(recordingJourney,
                                                                        userID: userID)
                switch result {
                case .success(let cancelledJourney):
                    #if DEBUG
                    MSLogger.make(category: .home).debug("여정이 취소 되었습니다: \(cancelledJourney)")
                    #endif
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        /// 업데이트되는 위치 정보를 받아와 10개가 될 경우 필터링 후 저장하는 로직
        case .tenLocationsDidRecorded(let coordinate):
            self.filterCoordinate(coordinate: coordinate)
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
    
    /// 배열의 중앙값을 도출
    func findMedianFrom(array: [CLLocationDegrees]) -> CLLocationDegrees {
        let sortedArray = array.sorted()
        let count = sortedArray.count

        if count % 2 == 0 {
            // Array has even number of elements
            let middle1 = sortedArray[count / 2 - 1]
            let middle2 = sortedArray[count / 2]
            return (middle1 + middle2) / 2.0
        } else {
            // Array has odd number of elements
            return sortedArray[count / 2]
        }
    }
    
    /// 위도 배열, 경도 배열로부터 중앙값을 도출
    func medianCoordinate(recordedCoordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        
        // 10개의 위도 값 배열 생성
        let latitudes = recordedCoordinates.map { coord in
            coord.latitude
        }.sorted()
        
        // 10개의 경도 값 배열 생성
        let longitudes = recordedCoordinates.map { coord in
            coord.longitude
        }.sorted()
        
        return CLLocationCoordinate2D(latitude: findMedianFrom(array: latitudes),
                                      longitude: findMedianFrom(array: longitudes))
    }
    
    /// 위도 배열, 경도 배열로부터 평균값을 도출
    func averageCoordinate(recordedCoordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        let recordedLength = recordedCoordinates.count
        let initialCoordinate = recordedCoordinates.reduce(CLLocationCoordinate2D(latitude: 0,
                                                                                  longitude: 0)) { result, coordinate in
            return CLLocationCoordinate2D(latitude: result.latitude + coordinate.latitude,
                                          longitude: result.longitude + coordinate.longitude)
        }
        let initialLat = initialCoordinate.latitude
        let initialLong = initialCoordinate.longitude
        return CLLocationCoordinate2D(latitude: initialLat / Double(recordedLength),
                                      longitude: initialLong / Double(recordedLength))
    }
    
    /// 두 위치의 거리를 구하기
    func distanceWith(_ coordinate1: CLLocationCoordinate2D,
                      _ coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude,
                                   longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude,
                                   longitude: coordinate2.longitude)
        
        return location1.distance(from: location2)
    }
    
    /// 현재 location들 중 평균으로부터 가장 먼 지점을 제거
    func deleteFarLocation(recordedCoordinates: [CLLocationCoordinate2D],
                           average: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        var coordinates = recordedCoordinates
        var maxDistance = 0.0
        var maxDistanceIndex = -1
        for (index, coordinate) in recordedCoordinates.enumerated() {
            let location1 = CLLocation(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude)
            let location2 = CLLocation(latitude: average.latitude,
                                       longitude: average.longitude)
            let distance = location1.distance(from: location2)
            if distance > maxDistance {
                maxDistance = distance
                maxDistanceIndex = index
            }
        }
        coordinates.remove(at: maxDistanceIndex)
        return coordinates
        
    }
    
    func filterCoordinate(coordinate: CLLocationCoordinate2D) {
        if let previousCoordinate = self.state.previousCoordinate.value,
           calculateDistance(from: previousCoordinate,
                             to: coordinate) <= 5 {
            return
        }
        var recordedCoords = self.state.recordedCoordinates.value
        recordedCoords.append(coordinate)
        self.state.recordedCoordinates.send(recordedCoords)
        
        if self.state.recordedCoordinates.value.count >= 10 {
            
            var finalAverage = CLLocationCoordinate2D()
            
            while true {
                let average = averageCoordinate(recordedCoordinates: recordedCoords)
                let median = medianCoordinate(recordedCoordinates: recordedCoords)
                
                if distanceWith(average,
                                median) <= 10 {
                    finalAverage = average
                    break
                } else {
                    recordedCoords = deleteFarLocation(recordedCoordinates: recordedCoords,
                                                       average: average)
                }
                
                if recordedCoords.count == 1 {
                    finalAverage = recordedCoords[0]
                    break
                }
            }
            
            self.state.filteredCoordinate.send(finalAverage)
            self.state.recordedCoordinates.send([])
        }
    }
}
