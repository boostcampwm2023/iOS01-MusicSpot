//
//  SaveJourneyViewModel.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine
import Foundation
import MusicKit

import MSDomain
import MSLogger

public final class SaveJourneyViewModel {
    public enum Action {
        case viewNeedsLoaded
        case musicControlButtonDidTap
        case titleDidConfirmed(String)
    }
    
    public struct State {
        // Passthrough
        var endJourneySucceed = PassthroughSubject<Journey, Never>()
        
        // CurrentValue
        /// Apple Music 권한 상태
        var musicAuthorizatonStatus = CurrentValueSubject<MusicAuthorization.Status, Never>(.notDetermined)
        var buttonStateFactors = CurrentValueSubject<ButtonStateFactor, Never>(ButtonStateFactor())
        var isDoneButtonLoading = CurrentValueSubject<Bool, Never>(false)
        
        var recordingJourney = CurrentValueSubject<RecordingJourney?, Never>(nil)
        var selectedSong: CurrentValueSubject<Song, Never>
    }
    
    // MARK: - Properties
    
    private var journeyRepository: JourneyRepository
    
    public var state: State
    
    /// 완료 버튼을 누른 시점의 마지막 좌표
    private let lastCoordiante: Coordinate
    
    // MARK: - Initializer
    
    public init(lastCoordinate: Coordinate,
                selectedSong: Song,
                journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
        self.state = State(selectedSong: CurrentValueSubject<Song, Never>(selectedSong))
        self.lastCoordiante = lastCoordinate
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let status = await MusicAuthorization.request()
                #if DEBUG
                MSLogger.make(category: .saveJourney).info("음악 권한 상태: \(status)")
                #endif
                self.state.musicAuthorizatonStatus.send(status)
            }
            
            Task {
                let subscription = try await MusicSubscription.current
                #if DEBUG
                MSLogger.make(category: .saveJourney).debug("\(subscription)")
                #endif
                let stateFactors = self.state.buttonStateFactors.value
                stateFactors.canBecomeSubscriber = subscription.canBecomeSubscriber
                self.state.buttonStateFactors.send(stateFactors)
            }
            
            guard let recordingJourney = self.journeyRepository.fetchRecordingJourney() else { return }
            self.state.recordingJourney.send(recordingJourney)
        case .musicControlButtonDidTap:
            let stateFactors = self.state.buttonStateFactors.value
            stateFactors.isMusicPlaying.toggle()
            self.state.buttonStateFactors.send(stateFactors)
        case .titleDidConfirmed(let title):
            self.endJourney(named: title)
        }
    }
}

// MARK: - Private Functions

private extension SaveJourneyViewModel {
    func endJourney(named title: String) {
        self.state.isDoneButtonLoading.send(true)
        defer { self.state.isDoneButtonLoading.send(false) }
        
        guard let recordingJourney = self.state.recordingJourney.value else {
            return
        }
        
        let selectedSong = self.state.selectedSong.value
        let coordinates = recordingJourney.coordinates + [self.lastCoordiante]
        let journey = Journey(id: recordingJourney.id,
                              title: title,
                              date: (start: recordingJourney.startTimestamp, end: .now),
                              spots: recordingJourney.spots,
                              coordinates: coordinates,
                              music: Music(selectedSong))
        
        Task {
            let result = await self.journeyRepository.endJourney(journey)
            switch result {
            case .success(let journeyID):
                #if DEBUG
                MSLogger.make(category: .saveJourney).log("\(journeyID)가 저장되었습니다.")
                #endif
                self.state.endJourneySucceed.send(journey)
            case .failure(let error):
                MSLogger.make(category: .saveJourney).error("\(error)")
            }
        }
    }
}
