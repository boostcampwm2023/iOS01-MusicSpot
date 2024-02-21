//
//  SampleView.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.21.
//

import SwiftUI

private struct SampleView: View {
    
    // MARK: - Properties
    
    @State private var isExpanding: Bool = false
    @Namespace private var animation
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            SampleTab("Home", "play.circle.fill")
            SampleTab("Browse", "square.grid.2x2.fill")
            SampleTab("Radio", "dot.radiowaves.left.and.right")
            SampleTab("Library", "play.square.stack")
            SampleTab("Search", "magnifyingglass")
        }
        .tint(Color.msColor(.musicSpot))
        .safeAreaInset(edge: .bottom) {
            MinimizedMusicPlayer(isExpanding: self.$isExpanding,
                              animation: self.animation)            
                .offset(y: -49)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .overlay {
            if self.isExpanding {
                MSMusicPlayer(isExpanding: self.$isExpanding,
                              animation: self.animation)
                .transition(.asymmetric(insertion: .identity,
                                        removal: .offset(y: -5)))
            }
        }
    }
    
    // swiftlint: disable identifier_name
    @ViewBuilder
    func SampleTab(_ title: String, _ icon: String) -> some View {
        Text(title)
            .tabItem {
                Image(systemName: icon)
                Text(title)
            }
            .opacity(self.isExpanding ? .zero : 1.0)
    }
    // swiftlint: enable identifier_name
    
}

#Preview {
    SampleView()
}
