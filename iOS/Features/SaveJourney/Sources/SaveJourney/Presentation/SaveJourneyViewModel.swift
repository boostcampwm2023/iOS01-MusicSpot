//
//  SaveJourneyViewModel.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine
import MediaPlayer
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
        public var recordingJourney = CurrentValueSubject<RecordingJourney?, Never>(nil)
        var selectedSong: CurrentValueSubject<Song, Never>
        var isMusicPlaying = CurrentValueSubject<Bool, Never>(false)
        var mediaItem = PassthroughSubject<MPMediaQuery?, Never>()
        
        var endJourneyResponse = CurrentValueSubject<String?, Never>(nil)
    }
    
    // MARK: - Properties
    
    private var journeyRepository: JourneyRepository
    
    public var state: State
    
    /// 완료 버튼을 누른 시점의 마지막 좌표
    private let lastCoordiante: Coordinate
    /// 음악 검색 시 선택한 음악의 IndexPath
    private let selectedIndex: IndexPath
    
    // MARK: - Initializer
    
    public init(lastCoordinate: Coordinate,
                selectedSong: Song,
                selectedIndex: IndexPath,
                journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
        self.state = State(selectedSong: CurrentValueSubject<Song, Never>(selectedSong))
        self.lastCoordiante = lastCoordinate
        self.selectedIndex = selectedIndex
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            let mediaItem = self.querySong(self.state.selectedSong.value,
                                           at: self.selectedIndex.item)
            self.state.mediaItem.send(mediaItem)
            
            guard let recordingJourneyID = self.journeyRepository.fetchRecordingJourneyID(),
                  let recordingJourney = self.journeyRepository.fetchRecordingJourney(forID: recordingJourneyID) else {
                return
            }
            self.state.recordingJourney.send(recordingJourney)
        case .mediaControlButtonDidTap:
            self.state.isMusicPlaying.send(!self.state.isMusicPlaying.value)
        case .titleDidConfirmed(let title):
            self.endJourney(named: title)
        case .endJourneyDidSucceed(let journeyID):
            self.state.endJourneyResponse.send(journeyID)
        }
    }
    
}

// MARK: - Private Functions

private extension SaveJourneyViewModel {
    
    func endJourney(named title: String) {
        guard let recordingJourney = self.state.recordingJourney.value else { return }
        
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
    }
    
    func querySong(_ song: Song, at index: Int) -> MPMediaQuery {
        let mediaQuery = MPMediaQuery.songs()
        
        let titlePredicate = MPMediaPropertyPredicate(value: song.title,
                                                      forProperty: MPMediaItemPropertyTitle)
        
        mediaQuery.addFilterPredicate(titlePredicate)
        
        return mediaQuery
    }
    
}
