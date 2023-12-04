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
import MSNetworking

final class RewindJourneyViewModel {
    
    // MARK: - Properties
    
    private var subscriber: Set<AnyCancellable> = []
    
    // MARK: - Properties: Networking
    
    private let msNetworking = MSNetworking(session: URLSession.shared)
    
    // MARK: - Properties: Timer
    
    private let timerTimeInterval: Double = 4.0
    internal let timerPublisher = PassthroughSubject<Void, Never>()
    private var timer: AnyCancellable?
    
}

// MARK: - Interface: Networking

extension RewindJourneyViewModel {
    
    func downloadImages(using router: Router?, journeyID: UUID?) {
        guard let router, let journeyID else {
            MSLogger.make(category: .rewindJourney).debug("journeyID 또는 router이 view model에 전달되지 않았습니다.")
            return
        }
        
        self.msNetworking.request(JourneyDTO.self, router: router)
            .sink { response in
                switch response {
                case .failure(let error):
                    MSLogger.make(category: .network).debug("\(error): 정상적으로 Spot을 서버에 보내지 못하였습니다.")
                default:
                    return
                }
            } receiveValue: { _ in
                
//                let spots = journeyDTO.spots
//                let imageURLs = spots.forEach { $0.photo }
//                return imagesURLs
                
            }
            .store(in: &subscriber)
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
