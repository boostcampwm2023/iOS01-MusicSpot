//
//  JourneyRepository.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Combine
import Foundation

import MSConstants
import MSDomain
import MSNetworking
import MSPersistentStorage
import MSUserDefaults

public protocol JourneyRepository {
    
    func fetchRecordingJourneyID() -> String?
    func fetchRecordingJourney(forID id: String) -> RecordingJourney?
    func fetchJourneyList(userID: UUID,
                          minCoordinate: Coordinate,
                          maxCoordinate: Coordinate) async -> Result<[Journey], Error>
    mutating func startJourney(at coordinate: Coordinate, userID: UUID) async -> Result<RecordingJourney, Error>
    mutating func endJourney(_ journey: Journey) async -> Result<String, Error>
    func recordJourney(journeyID: String, at coordinates: [Coordinate]) async -> Result<RecordingJourney, Error>
    
}

public struct JourneyRepositoryImplementation: JourneyRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    private let persistent: MSPersistentStorage
    
    @UserDefaultsWrapped(UserDefaultsKey.recordingJourneyID, defaultValue: nil)
    private var recordingJourneyID: String?
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default),
                fileManager: FileManager = FileManager()) {
        self.networking = MSNetworking(session: session)
        self.persistent = FileManagerStorage(fileManager: fileManager)
    }
    
    // MARK: - Functions
    
    public func fetchRecordingJourneyID() -> String? {
        return self.recordingJourneyID
    }
    
    public func fetchRecordingJourney(forID id: String) -> RecordingJourney? {
        return self.persistent.get(RecordingJourneyDTO.self, forKey: id)?.toDomain()
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
    
    public mutating func startJourney(at coordinate: Coordinate,
                                      userID: UUID) async -> Result<RecordingJourney, Error> {
        #if MOCK
        let recordingJourneyID = "657537c178b6463b9f810371"
        let recordingJourney = RecordingJourney(id: recordingJourneyID,
                                                startTimestamp: .now,
                                                spots: [],
                                                coordinates: [])
        self.recordingJourneyID = recordingJourneyID
        return .success(recordingJourney)
        #else
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
            self.recordingJourneyID = recordingJourney.id
            return .success(recordingJourney)
        case .failure(let error):
            return .failure(error)
        }
        #endif
    }
    
    public func recordJourney(journeyID: String,
                              at coordinates: [Coordinate]) async -> Result<RecordingJourney, Error> {
        let coordinatesDTO = coordinates.map { CoordinateDTO($0) }
        let requestDTO = RecordCoordinateRequestDTO(journeyID: journeyID, coordinates: coordinatesDTO)
        let router = JourneyRouter.recordCoordinate(dto: requestDTO)
        let result = await self.networking.request(RecordCoordinateRequestDTO.self, router: router)
        switch result {
        case .success(let responseDTO):
            let coordinates = responseDTO.coordinates.map { $0.toDomain() }
            let recordingJourney = RecordingJourney(id: responseDTO.journeyID,
                                               startTimestamp: Date(),
                                               spots: [],
                                               coordinates: coordinates)
            return .success(recordingJourney)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public mutating func endJourney(_ journey: Journey) async -> Result<String, Error> {
        let requestDTO = EndJourneyRequestDTO(journeyID: journey.id,
                                              coordinates: journey.coordinates.map { CoordinateDTO($0) },
                                              endTimestamp: journey.date.end,
                                              title: journey.title,
                                              song: SongDTO(journey.music))
        let router = JourneyRouter.endJourney(dto: requestDTO)
        let result = await self.networking.request(EndJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let responseDTO):
            self.recordingJourneyID = nil
            return .success(responseDTO.id)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
