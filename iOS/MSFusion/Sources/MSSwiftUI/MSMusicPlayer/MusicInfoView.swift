//
//  MusicInfoView.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.21.
//

import SwiftUI

struct MusicInfoView: View {
    
    // MARK: - Constants
    
    private enum Metric {
        static let height: CGFloat = 40.0
        static let artworkSize: CGFloat = 40.0
    }
    
    // MARK: - Properties
    
    @Binding var isExpanding: Bool
    var animation: Namespace.ID
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: .zero) {
            /// Hero Animation
            ZStack {
                if !self.isExpanding {
                    GeometryReader {
                        let size = $0.size
                        Image.msIcon(.logoWithBackground)?
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: self.isExpanding ? 15.0 : 5.0,
                                                        style: .continuous))
                    }
                    .matchedGeometryEffect(id: MusicPlayerConstants.ID.artwork,
                                           in: self.animation)
                }
            }
            .frame(width: Metric.artworkSize, height: Metric.artworkSize)
            
            Text("Attention With Your Pretty Eyes")
                .font(.msFont(.caption))
                .lineLimit(1)
                .padding(.horizontal, 12.0)
            
            Spacer(minLength: .zero)
            
            Button {
                
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            
            Button {
                
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.trailing, 12.0)
            .padding(.leading, 24.0)
        }
        .foregroundStyle(Color.msColor(.primaryTypo))
        .padding(.horizontal, 8.0)
        .frame(height: Metric.height)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isExpanding = true
            }
        }
    }
    
}
