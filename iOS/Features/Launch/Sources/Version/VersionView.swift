//
//  VersionView.swift
//  Version
//
//  Created by 이창준 on 2024.02.13.
//

import SwiftUI

public struct VersionView: View {
    
    public var body: some View {
        Button("업데이트") {
            print("업데이트")
        }
        .buttonStyle(.borderless)
        .padding()
        .background(.green, in: Capsule())
    }
    
}

// MARK: - Preview

#Preview {
    VersionView()
}
