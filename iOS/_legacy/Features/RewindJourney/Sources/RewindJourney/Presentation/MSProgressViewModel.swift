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
    
    private enum Metric {
        static let timeInterval: Double = 0.01
    }
    
    // MARK: - Properties
    
    internal let timerPublisher = PassthroughSubject<Double, Never>()
    private var timer: AnyCancellable?
    
    private let timerDuration: Double
    private var remainingTime: Double
    
    // MARK: Initializers
    
    internal init(duration: TimeInterval) {
        self.timerDuration = duration
        self.remainingTime = duration
    }

    // MARK: - Functions: Timers

    internal func startTimer() {
        self.timer = Timer.publish(every: Metric.timeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                guard let remainingTime = self?.remainingTime,
                      let timerDuration = self?.timerDuration else {
                    return
                }
                
                self?.remainingTime -= Metric.timeInterval
                if remainingTime >= 0 {
                    let currentPercentage: Double = (timerDuration - remainingTime) / timerDuration
                    self?.timerPublisher.send(currentPercentage)
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
