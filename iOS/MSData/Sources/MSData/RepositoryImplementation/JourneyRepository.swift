//
//  JourneyRepository.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Combine
import Foundation

import MSDomain
import MSLogger
import MSNetworking
import MSPersistentStorage

public struct JourneyRepositoryImplementation: JourneyRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    private let storage: MSPersistentStorage
    
    private var recordingJourney: RecordingJourneyStorage
    
    public var isRecording: Bool {
        return self.recordingJourney.isRecording
    }
    
    public var recordingJourneyID: String? {
        return self.recordingJourney.id
    }
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default),
                persistentStorage: MSPersistentStorage = FileManagerStorage()) {
        self.networking = MSNetworking(session: session)
        self.storage = persistentStorage
        self.recordingJourney = RecordingJourneyStorage.shared
    }
    
    // MARK: - Functions
    
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
    
    public func fetchRecordingJourney() -> RecordingJourney? {
        guard let recordingJourneyID = self.fetchRecordingJourneyID(),
              let recordingJourney = self.fetchRecordingJourney(forID: recordingJourneyID) else {
            return nil
        }
        return recordingJourney
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
            self.recordingJourney.start(initialData: recordingJourney)
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
        let result = await self.networking.request(RecordJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let responseDTO):
            let coordinates = responseDTO.coordinates.map { $0.toDomain() }
            let recordingJourney = RecordingJourney(id: journeyID,
                                                    startTimestamp: Date(),
                                                    spots: [],
                                                    coordinates: coordinates)
            self.recordingJourney.record(responseDTO.coordinates, keyPath: \.coordinates)
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
            do {
                try self.recordingJourney.finish()
                return .success(responseDTO.id)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public mutating func deleteJourney(_ recordingJourney: RecordingJourney,
                                       userID: UUID) async -> Result<String, Error> {
        let requestDTO = DeleteJourneyRequestDTO(userID: userID, journeyID: recordingJourney.id)
        let router = JourneyRouter.deleteJourney(dto: requestDTO)
        let result = await self.networking.request(DeleteJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let responseDTO):
            do {
                try self.recordingJourney.finish()
                return .success(responseDTO.id)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
}

// MARK: - Private Functions

private extension JourneyRepositoryImplementation {
    
    func fetchRecordingJourneyID() -> String? {
        guard let recordingJourneyID = self.recordingJourney.id else {
            MSLogger.make(category: .recordingJourneyStorage).error("기록 중인 여정 정보를 가져오는데 실패했습니다.")
            return nil
        }
        return recordingJourneyID
    }
    
    func fetchRecordingJourney(forID id: String) -> RecordingJourney? {
        return self.storage.get(RecordingJourneyDTO.self, forKey: id)?.toDomain()
    }
    
}