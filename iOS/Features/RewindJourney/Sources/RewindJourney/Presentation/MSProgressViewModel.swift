//
//  MSProgressViewModel.swift
//  RewindJourney
//
//  Created by 전민건 on 12/4/23.
//

import Combine
import Foundation

final class MSProgressViewModel {
    
    // MARK: - Constants
    
    private let timerDuration: Double = 4.0
    private let timerTimeInterval: Double = 0.01
    
    // MARK: - Properties
    
    internal let timerPublisher = PassthroughSubject<Float, Never>()
    private var timer: AnyCancellable?
    private var remainingTime: Double
    
    // MARK: Initializers
    
    init() {
        self.remainingTime = self.timerDuration
    }

    // MARK: - Functions: Timers

    internal func startTimer() {
        self.timer = Timer.publish(every: self.timerTimeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                guard let remainingTime = self?.remainingTime,
                      let timerDuration = self?.timerDuration,
                      let timerTimeInterval = self?.timerTimeInterval else { return }
                
                self?.remainingTime -= timerTimeInterval
                if remainingTime >= 0 {
                    let currentPercentage = ( timerDuration - remainingTime ) / timerDuration
                    self?.timerPublisher.send(Float(currentPercentage))
                } else {
                    self?.timerPublisher.send(1.0)
                    self?.stopTimer()
                }
            }
    }

    internal func stopTimer() {
        self.timer?.cancel()
        self.remainingTime = self.timerDuration
    }
    
}
