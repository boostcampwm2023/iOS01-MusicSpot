//
//  ButtonStateFactor.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.09.
//

import Foundation

final class ButtonStateFactor: ObservableObject {
    @Published var canBecomeSubscriber: Bool = false
    @Published var isMusicPlaying: Bool = false
}
