//
//  Home+View.swift
//  Home
//
//  Created by 이창준 on 4/15/24.
//

import MapKit
import SwiftUI

import MSSwiftUI

@MainActor
extension Home: View {
    
    // MARK: - Constants
    
    private enum Typo {
        static let startButtonTitle = "시작하기"
    }
    
    private enum Metric {
        static let startButtonBottomPadding: CGFloat = 15.0
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
                Map(
                    position: self.$locationManager.position,
                    bounds: MapCameraBounds(maximumDistance: 2_000)
                ) {
                    UserAnnotation()
                }
                
                VStack {
                    MSRectSecondaryButton(image: .msIcon(.map)) {
                        self.perform(.mapButtonDidTap)
                    }
                    MSRectSecondaryButton(image: .msIcon(.location)) {
                        self.perform(.locationButtonDidTap)
                    }
                }
                .padding()
                
                VStack {
                    Spacer()
                    MSPrimaryButton(title: Typo.startButtonTitle, cornerStyle: .rounded) {
                        self.perform(.startButtonDidTap)
                    }
                    .opacity(
                        self.sheetHeight >= (proxy.size.height / 2) ? .zero : 1.0
                    )
                    .offset(
                        // Button center - Button height / 2 - Padding
                        y: -(min(self.sheetHeight, proxy.size.height / 2) +
                             MSLargeButtonStyle.Metric.height / 2 + Metric.startButtonBottomPadding)
                    )
                    .animation(.snappy(duration: 0.3), value: self.sheetHeight)
                }
                .frame(maxWidth: .infinity)
            }
            .sheet(isPresented: self.$isPresentingSheet) {
                GeometryReader { sheetProxy in
                    self.sheetHeight = sheetProxy.size.height
                    return VStack {
                        
                    }
                    .presentationDetents([.height(60.0), .medium, .fraction(0.99)])
                    .presentationCornerRadius(20.0)
                    .presentationBackground(Color.msColor(.primaryBackground))
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
}

// MARK: - Preview

#if targetEnvironment(simulator)
import MSDesignSystem

#Preview {
    MSFont.registerFonts()
    return Home()
}
#endif
