//
//  MusicControlButton.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.09.
//

import MusicKit
import SwiftUI

import MSDesignSystem

struct MusicControlButton: View {
    
    // MARK: - State
    
    @ObservedObject var stateFactor: ButtonStateFactor
    
    @State var isShowingOffer = false
    
    // MARK: - Properties
    
    var song: Song?
    var musicControlAction: (() -> Void)?
    
    var offerOptions: MusicSubscriptionOffer.Options {
        var offerOptions = MusicSubscriptionOffer.Options()
        offerOptions.itemID = self.song?.id
        offerOptions.messageIdentifier = .join
        return offerOptions
    }
    
    // MARK: - View
    
    let haptic: UIImpactFeedbackGenerator = {
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.prepare()
        return haptic
    }()
    
    var body: some View {
        Button(action: self.showSubscriptionOffer) {
            if self.stateFactor.canBecomeSubscriber {
                Image(uiImage: .msIcon(.lock) ?? .actions)
            } else {
                let image: UIImage? = self.stateFactor.isMusicPlaying ? .msIcon(.pause) : .msIcon(.play)
                Image(uiImage: image ?? .actions)
            }
        }
        .frame(width: 52.0, height: 60.0, alignment: .center)
        .musicSubscriptionOffer(isPresented: self.$isShowingOffer, options: self.offerOptions)
        .foregroundStyle(Color(uiColor: .msColor(.secondaryButtonTypo)))
        .background(Color(uiColor: .msColor(.secondaryButtonBackground)))
        .cornerRadius(5.0)
    }
    
    private func showSubscriptionOffer() {
        self.haptic.impactOccurred()
        
        if self.stateFactor.canBecomeSubscriber {
            self.isShowingOffer = true
        } else {
            self.musicControlAction?()
        }
    }
    
}
