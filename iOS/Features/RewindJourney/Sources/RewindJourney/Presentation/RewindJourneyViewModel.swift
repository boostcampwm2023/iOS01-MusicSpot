//
//  RewindJourneyViewModel.swift
//  RewindJourney
//
//  Created by 전민건 on 11/30/23.
//

import Foundation
import Combine

import MSData
import MSLogger

public final class RewindJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        var stateJourneyPhotoURLs = CurrentValueSubject<[URL], Never>([])
    }
    
    // MARK: - Properties
    
    private var subscriber: Set<AnyCancellable> = []
    private let repository: SpotRepository
    public var state = State()
    
    // MARK: - Properties: Timer
    
    private let timerTimeInterval: Double = 4.0
    internal let timerPublisher = PassthroughSubject<Void, Never>()
    private var timer: AnyCancellable?
    
    // MARK: - Initializer
    
    public init(repository: SpotRepository) {
        self.repository = repository
    }
    
}

// MARK: - Interface: Networking

extension RewindJourneyViewModel {
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let result = await self.repository.fetchRecordingSpots()
                switch result {
                case .success(let responseDTOs):
                    let photoURLs = responseDTOs
                        .map { Spot(dto: $0).photoURL }
                    self.state.stateJourneyPhotoURLs.send(photoURLs)
                case .failure(let error):
                    #if DEBUG
                    MSLogger.make(category: .saveJourney).error("\(error)")
                    #endif
                }
            }
        }
    }

}

// MARK: - Interface: Timer

internal extension RewindJourneyViewModel {
    
    func startTimer() {
        timer = Timer.publish(every: self.timerTimeInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerPublisher.send()
            }
    }

    func stopTimer() {
        self.timer?.cancel()
    }
    
}
