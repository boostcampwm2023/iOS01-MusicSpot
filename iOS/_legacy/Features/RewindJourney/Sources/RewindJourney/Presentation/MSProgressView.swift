//
//  MSProgressView.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import Combine
import UIKit

public final class MSProgressView: UIProgressView {
    // MARK: - Properties
    
    private var progressViewModel: MSProgressViewModel!
    private var timer: Set<AnyCancellable> = []
    
    internal var percentage: Double = 0.0 {
        willSet { self.syncProgress(percentage: newValue) }
    }
    
    internal var isHighlighted: Bool = false {
        didSet {
            if self.isHighlighted {
                if self.isLeftOfCurrentHighlighting {
                    self.progressViewModel.stopTimer()
                    self.percentage = 1.0
                } else {
                    self.progressViewModel.startTimer()
                }
            } else {
                self.progressViewModel.stopTimer()
                self.percentage = 0.0
            }
        }
    }
    
    internal var isLeftOfCurrentHighlighting: Bool = false
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect = .zero, duration: TimeInterval) {
        self.init(frame: frame)
        self.configureColor()
        self.progressViewModel = MSProgressViewModel(duration: duration)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Configure
    
    private func configureColor() {
        self.trackTintColor = .systemGray6
        self.tintColor = .white
    }
    
    // MARK: - Functions: change progress
    
    private func syncProgress(percentage: Double) {
        DispatchQueue.main.async { self.progress = Float(percentage) }
    }
    
    // MARK: - Timer
    
    private func bind() {
        self.progressViewModel.timerPublisher
            .sink { [weak self] currentPercentage in
                self?.percentage = currentPercentage
            }
            .store(in: &self.timer)
    }
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    let progressView = MSProgressView()
    return progressView
}
