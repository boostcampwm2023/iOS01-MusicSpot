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
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Map(initialPosition: .userLocation(fallback: .automatic)) {
                Marker("ldskfj", coordinate: .init(latitude: 42, longitude: 42))
            }
            
            MSPrimaryButton(title: "시작하기", cornerStyle: .rounded) {
                print("Start")
            }
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
