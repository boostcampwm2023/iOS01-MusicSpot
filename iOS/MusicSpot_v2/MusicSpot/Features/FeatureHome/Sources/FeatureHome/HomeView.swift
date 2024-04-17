//
//  HomeView.swift
//  FeatureHome
//
//  Created by 이창준 on 4/15/24.
//

import MapKit
import SwiftUI

@MainActor
struct HomeView: View {
    
    // MARK: - Properties
    
    var viewModel = HomeStore()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Map(initialPosition: .userLocation(fallback: .automatic)) {
                Marker("ldskfj", coordinate: .init(latitude: 42, longitude: 42))
                
            }
            .mapControls {
                MapUserLocationButton()
            }
            
            VStack {
                Spacer()
                Button {
                    Task {
                        await self.viewModel.process(.increaseCounter)
                    }
                } label: {
                    Text("Increase")
                }
                Text("\(self.viewModel.counter)")
            }
        }
    }
    
}

#Preview {
    HomeView()
}
