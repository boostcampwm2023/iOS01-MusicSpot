//
//  MinimizedMusicPlayer.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.21.
//

import SwiftUI

import MSDesignSystem

public struct MinimizedMusicPlayer: View {
    
    // MARK: - Properties
    
    // Animations
    @Binding var isExpanding: Bool
    var animation: Namespace.ID
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            if self.isExpanding {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(Color.msColor(.componentBackgroundSolid))
                    .overlay {
                        MusicInfoView(isExpanding: self.$isExpanding,
                                      animation: self.animation)
                    }
                    .matchedGeometryEffect(id: MusicPlayerConstants.ID.backgroundView,
                                           in: self.animation)
            }
            
            Rectangle()
                .fill(Color.msColor(.componentBackgroundSolid))
                .overlay {
                    MusicInfoView(isExpanding: self.$isExpanding,
                                  animation: self.animation)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        .frame(height: 60.0)
    }
    
}

// MARK: - Preview

#Preview("Minimized") {
    @State var isExpanding: Bool = false
    @Namespace var animation
    
    MSFont.registerFonts()
    
    return VStack {
        Spacer()
        MinimizedMusicPlayer(isExpanding: $isExpanding, animation: animation)
            .offset(y: -49)
            .padding(.horizontal)
    }
}

#Preview("Expanded") {
    @State var isExpanding: Bool = true
    @Namespace var animation
    
    MSFont.registerFonts()
    
    return VStack {
        Spacer()
        MinimizedMusicPlayer(isExpanding: $isExpanding, animation: animation)
            .offset(y: -49)
            .padding(.horizontal)
    }
}
