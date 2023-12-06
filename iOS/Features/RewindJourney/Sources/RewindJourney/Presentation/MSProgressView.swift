//
//  MSProgressView.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import UIKit
import Combine

public final class MSProgressView: UIProgressView {
    
    // MARK: - Properties
    
    private let progressViewModel = MSProgressViewModel()
    private var timerSubscriber: Set<AnyCancellable> = []
    internal var percentage: Float = 0.0 {
        didSet {
            syncProgress(percentage: percentage)
        }
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureColor()
        self.timerBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based 로 개발되었습니다.")
    }
    
    // MARK: - Configure
    
    private func configureColor() {
        self.trackTintColor = .systemGray6
        self.tintColor = .white
    }
    
    // MARK: - Functions: change progress
    
    private func syncProgress(percentage: Float) {
        self.progress = percentage
    }
    
    // MARK: - Timer
    
    private func timerBinding() {
        self.progressViewModel.timerPublisher
            .sink { [weak self] currentPercentage in
                self?.percentage = currentPercentage
                print(currentPercentage)
            }
            .store(in: &timerSubscriber)
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    let progressView = MSProgressView()
    return progressView
}
