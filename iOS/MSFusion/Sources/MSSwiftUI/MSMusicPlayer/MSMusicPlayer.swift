//
//  MSMusicPlayer.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.21.
//

import SwiftUI

import MSDesignSystem

struct MSMusicPlayer: View {
    
    // MARK: - Constants
    
    private enum Metric {
        static let horizontalPadding: CGFloat = 25.0
    }
    
    // MARK: - Properties
    
    @Binding var isExpanding: Bool
    var animation: Namespace.ID
    
    @State private var isAnimating: Bool = false
    @State private var offsetY: CGFloat = .zero
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(Color.msColor(.componentBackgroundSolid))
                    .overlay {
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                            .fill(Color.msColor(.componentBackgroundSolid))
                            .opacity(self.isAnimating ? 1 : .zero)
                    }
                    .overlay(alignment: .top) {
                        MusicInfoView(isExpanding: self.$isExpanding,
                                      animation: self.animation)
                        .allowsHitTesting(false)
                        .opacity(self.isAnimating ? .zero : 1)
                    }
                    .matchedGeometryEffect(id: MusicPlayerConstants.ID.backgroundView,
                                           in: self.animation)
                
                VStack(spacing: 15.0) {
                    // Resize Indicator
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40.0, height: 5.0)
                        .opacity(self.isAnimating ? 1 : .zero)
                        .offset(y: self.isAnimating ? .zero : size.height)
                    
                    // Artwork Hero
                    GeometryReader {
                        let size = $0.size
                        
                        Image.msIcon(.logoWithBackground)?
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: self.isAnimating ? 15.0 : 5.0,
                                                        style: .continuous))
                    }
                    .matchedGeometryEffect(id: MusicPlayerConstants.ID.artwork,
                                           in: self.animation)
                    .frame(height: size.width - (Metric.horizontalPadding * 2))
                    // 홈 버튼 아이폰 대응
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    PlayerView(size: size)
                        .offset(y: self.isAnimating ? .zero : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == .zero ? 10 : .zero))
                .padding(.bottom, safeArea.bottom == .zero ? 10 : safeArea.bottom)
                .padding(.horizontal, Metric.horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .contentShape(Rectangle())
            .offset(y: self.offsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translationY = value.translation.height
                        self.offsetY = max(translationY, .zero)
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            let isSnappingDown = {
                                value.velocity.height > 1_000
                                && value.translation.height > .zero
                            }()
                            
                            if isSnappingDown || self.offsetY > size.height * 0.4 {
                                self.isExpanding = false
                                self.isAnimating = false
                            } else {
                                self.offsetY = .zero
                            }
                        }
                    }
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                self.isAnimating = true
            }
        }
    }
    
    // swiftlint: disable identifier_name
    @ViewBuilder
    func PlayerView(size: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            let spacing = size.height * 0.04
            
            VStack(spacing: spacing) {
                // Info & Playback
                VStack(spacing: spacing) {
                    // Title & Artist
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text("Attention")
                            .font(.msFont(.headerTitle))
                        
                        Text("New Jeans")
                            .font(.msFont(.paragraph))
                    }
                    .foregroundStyle(Color.msColor(.primaryTypo))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Playback Time Progress
                    Capsule()
                        .fill(Color.msColor(.componentTypo))
                        .frame(height: 5.0)
                        .padding(.top, spacing)
                    
                    // Playback Time Label
                    HStack {
                        Text("0:00")
                        Spacer(minLength: .zero)
                        Text("3:14")
                    }
                    .font(.msFont(.caption))
                    .foregroundStyle(Color.msColor(.componentTypo))
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                // Controllers
                HStack(spacing: size.width * 0.18) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "pause.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50.0))
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundStyle(Color.msColor(.primaryTypo))
                .frame(maxHeight: .infinity, alignment: .center)
                
                // Volume & etc
                VStack(spacing: 16.0) {
                    HStack(spacing: 16.0) {
                        Image(systemName: "speaker.fill")
                        Capsule()
                            .fill(Color.msColor(.componentTypo))
                            .frame(height: 5.0)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    .foregroundStyle(Color.msColor(.componentTypo))
                    
                    HStack(alignment: .top, spacing: size.width * 0.25) {
                        Button {
                            
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "airplayaudio")
                                .font(.title2)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                    }
                    .foregroundStyle(Color.msColor(.componentTypo))
                    .blendMode(.hardLight)
                    .padding(.top, spacing)
                }
                .frame(height: size.height / 2.5, alignment: .bottom)
            }
        }
    }
    // swiftlint: enable identifier_name
    
}

#Preview {
    MSFont.registerFonts()
    
    @Namespace var animation
    return MSMusicPlayer(isExpanding: .constant(true),
                         animation: animation)
}
