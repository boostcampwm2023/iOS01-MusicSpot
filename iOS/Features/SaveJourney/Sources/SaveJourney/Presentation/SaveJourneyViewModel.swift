//
//  SaveJourneyViewModel.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine
import MusicKit

import MSData
import MSDomain
import MSLogger

public final class SaveJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case mediaControlButtonDidTap
        case titleDidConfirmed(String)
        case endJourneyDidSucceed(String)
    }
    
    public struct State {
        var recordingJourney: CurrentValueSubject<RecordingJourney, Never>
        var selectedSong: CurrentValueSubject<Song, Never>
        var spots = CurrentValueSubject<[Spot], Never>([])
        var endJourneyResponse = CurrentValueSubject<String?, Never>(nil)
    }
    
    // MARK: - Properties
    
    private let journeyRepository: JourneyRepository
    
    public var state: State
    
    /// 완료 버튼을 누른 시점의 마지막 좌표
    private let lastCoordiante: Coordinate
    
    // MARK: - Initializer
    
    public init(recordingJourney: RecordingJourney,
                lastCoordinate: Coordinate,
                selectedSong: Song,
                journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
        self.state = State(recordingJourney: CurrentValueSubject<RecordingJourney, Never>(recordingJourney),
                           selectedSong: CurrentValueSubject<Song, Never>(selectedSong))
        self.lastCoordiante = lastCoordinate
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            #if DEBUG
            MSLogger.make(category: .saveJourney).log("View Did Load: SaveJourney")
            #endif
        case .mediaControlButtonDidTap:
            print("Media Control Button Tap.")
        case .titleDidConfirmed(let title):
            let selectedSong = self.state.selectedSong.value
            let recordingJourney = self.state.recordingJourney.value
            let journey = Journey(id: recordingJourney.id,
                                  title: title,
                                  date: (recordingJourney.startTimestamp, .now),
                                  spots: recordingJourney.spots,
                                  coordinates: recordingJourney.coordinates,
                                  music: Music(selectedSong))
            Task {
                let result = await self.journeyRepository.endJourney(journey)
                switch result {
                case .success(let journey):
                    #if DEBUG
                    MSLogger.make(category: .saveJourney).log("\(journey)가 저장되었습니다.")
                    #endif
                    self.trigger(.endJourneyDidSucceed(journey))
                case .failure(let error):
                    #if DEBUG
                    MSLogger.make(category: .saveJourney).error("\(error)")
                    #endif
                }
            }
        case .endJourneyDidSucceed(let journeyID):
            self.state.endJourneyResponse.send(journeyID)
        }
    }
    
}
