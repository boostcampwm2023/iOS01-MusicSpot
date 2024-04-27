//
//  Home+View.swift
//  Home
//
//  Created by 이창준 on 4/15/24.
//

import MapKit
import SwiftUI

import Journey
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
                Map(position: self.$locationManager.position, scope: self.mapScope) {
                    UserAnnotation()
                }
                .mapControls {
                    MapScaleView()
                }
                .mapStyle(self.selectedMapStyle)
                
                VStack {
                    MSRectSecondaryButton(image: .msIcon(.map)) {
                        self.perform(.mapButtonDidTap)
                    }
                    MapUserLocationButton(scope: self.mapScope)
                        .tint(.msColor(.secondaryButtonTypo))
                        .background(Color.msColor(.secondaryButtonBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        .shadow(
                            color: .msColor(.secondaryButtonTypo).opacity(0.3),
                            radius: 2.5, x: .zero, y: 2.0
                        )
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
            .mapScope(self.mapScope)
            .sheet(isPresented: self.$isPresentingSheet) {
                GeometryReader { sheetProxy in
                    self.sheetHeight = sheetProxy.size.height
                    return JourneyList()
                        // FIXME: 최소화 모드 폰트 크기 조정에 따라 동적 조정 필요
                        .presentationDetents([.height(90.0), .medium, .fraction(0.99)])
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
