//
//  JourneyRepository.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Combine
import Foundation

import MSDomain
import MSNetworking

public protocol JourneyRepository {
    
    func fetchRecordingJourney() async -> Result<Journey, Error>
    func fetchJourneyList(userID: UUID,
                          minCoordinate: Coordinate,
                          maxCoordinate: Coordinate) async -> Result<[Journey], Error>
    func startJourney(at coordinate: Coordinate, userID: UUID) async -> Result<RecordingJourney, Error>
    func endJourney(_ journey: Journey) async -> Result<String, Error>
    
}

public struct JourneyRepositoryImplementation: JourneyRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.networking = MSNetworking(session: session)
    }
    
    // MARK: - Functions
    
    public func fetchRecordingJourney() async -> Result<Journey, Error> {
        return .failure(MSNetworkError.invalidRouter)
    }
    
    public func fetchJourneyList(userID: UUID,
                                 minCoordinate: Coordinate,
                                 maxCoordinate: Coordinate) async -> Result<[Journey], Error> {
        #if MOCK
        guard let jsonURL = Bundle.module.url(forResource: "MockJourney", withExtension: "json") else {
            return .failure((MSNetworkError.invalidRouter))
        }
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let responseDTO = try decoder.decode(CheckJourneyResponseDTO.self, from: jsonData)
            return .success(responseDTO.map { $0.toDomain() })
        } catch {
            return .failure(error)
        }
        #else
        let router = JourneyRouter.checkJourney(userID: userID,
                                                minCoordinate: CoordinateDTO(minCoordinate),
                                                maxCoordinate: CoordinateDTO(maxCoordinate))
        let result = await self.networking.request(CheckJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let response):
            return .success(response.map { $0.toDomain() })
        case .failure(let error):
            return .failure(error)
        }
        #endif
    }
    
    public func startJourney(at coordinate: Coordinate, userID: UUID) async -> Result<RecordingJourney, Error> {
        let requestDTO = StartJourneyRequestDTO(coordinate: CoordinateDTO(coordinate),
                                                startTimestamp: .now,
                                                userID: userID)
        let router = JourneyRouter.startJourney(dto: requestDTO)
        let result = await self.networking.request(StartJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let responseDTO):
            let recordingJourney = RecordingJourney(id: responseDTO.journeyID,
                                                    startTimestamp: responseDTO.startTimestamp,
                                                    spots: [],
                                                    coordinates: [responseDTO.coordinate.toDomain()])
            return .success(recordingJourney)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func endJourney(_ journey: Journey) async -> Result<String, Error> {
        let requestDTO = EndJourneyRequestDTO(journeyID: journey.id,
                                              coordinates: journey.coordinates.map { CoordinateDTO($0) },
                                              endTimestamp: journey.date.end,
                                              title: journey.title,
                                              song: SongDTO(journey.music))
        let router = JourneyRouter.endJourney(dto: requestDTO)
        let result = await self.networking.request(EndJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let responseDTO):
            return .success(responseDTO.id)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
