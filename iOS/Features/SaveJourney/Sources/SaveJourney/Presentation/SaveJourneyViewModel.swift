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
    }
    
    public struct State {
        var recordedJourney: CurrentValueSubject<RecordingJourney, Never>
        var selectedSong: CurrentValueSubject<Song, Never>
        var spots = CurrentValueSubject<[Spot], Never>([])
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
        self.state = State(recordedJourney: CurrentValueSubject<RecordingJourney, Never>(recordingJourney),
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
        }
    }
    
}
