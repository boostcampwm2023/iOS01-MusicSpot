//
//  JourneyList+View.swift
//  FeatureHome
//
//  Created by 이창준 on 4/22/24.
//

import SwiftUI

extension JourneyList: View {
    
    var body: some View {
        VStack(spacing: 20.0) {
            Spacer()
            
            Button {
                
            } label: {
                Text("로그인")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(Color.msColor(.primaryBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .ignoresSafeArea(.all, edges: .bottom)
        .shadow(radius: 2.0)
    }
    
}

#Preview {
    JourneyList()
}
