//
//  RewindJourneyViewModel.swift
//  RewindJourney
//
//  Created by 전민건 on 11/30/23.
//

import Foundation
import Combine

import MSData
import MSExtension
import MSImageFetcher
import MSLogger

public final class RewindJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case startAutoPlay
        case stopAutoPlay
    }
    
    public struct State {
        // Passthrough
        let timerPublisher = PassthroughSubject<Void, Never>()
        
        // CurrentValue
        public let photoURLs: CurrentValueSubject<[URL], Never>
    }
    
    // MARK: - Properties
    
    private let repository: SpotRepository
    
    public var state: State
    
    private var subscriber: Set<AnyCancellable> = []
    
    // MARK: - Properties: Timer
    
    private let timerTimeInterval: Double = 4.0
    private var timer: AnyCancellable?
    
    // MARK: - Initializer
    
    public init(photoURLs: [URL], repository: SpotRepository) {
        self.repository = repository
        self.state = State(photoURLs: CurrentValueSubject<[URL], Never>(photoURLs))
    }
    
}

// MARK: - Interface: Actions

extension RewindJourneyViewModel {
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let photoURLs = self.state.photoURLs.value
                
                for photoURL in photoURLs {
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            await MSImageFetcher.shared.fetchImage(from: photoURL, forKey: photoURL.paath())
                        }
                    }
                }
            }
        case .startAutoPlay:
            self.startTimer()
        case .stopAutoPlay:
            self.stopTimer()
        }
    }

}

// MARK: - Functions: Timer

private extension RewindJourneyViewModel {
    
    func startTimer() {
        self.timer = Timer.publish(every: self.timerTimeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                self?.state.timerPublisher.send()
            }
    }

    func stopTimer() {
        self.timer?.cancel()
    }
    
}
