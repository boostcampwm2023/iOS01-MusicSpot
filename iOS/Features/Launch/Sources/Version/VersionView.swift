//
//  VersionView.swift
//  Version
//
//  Created by 이창준 on 2024.02.13.
//

import SwiftUI

import MSSwiftUI
import VersionManager

public struct VersionView: View {
    
    // MARK: - Constants
    
    private enum Typo {
        static let title = """
        MusicSpot 앱
        업데이트 안내
        """
        
        static let description = """
        업데이트된 MusicSpot과 함께
        더 즐거운 여정을 함께해보세요.
        """
    }
    
    // MARK: - Properties
    
    private let version = VersionManager()
    
    private var releaseNote: String?
    
    // MARK: - Initializer
    
    public init(releaseNote: String? = nil) {
        self.releaseNote = releaseNote
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16.0) {
                Image("logo", bundle: .msDesignSystem)
                    .resizable()
                    .frame(width: 50, height: 60, alignment: .leading)
                    .padding(.vertical, 60.0)
                Text(Typo.title)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(Typo.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(self.releaseNote ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            Button {
                guard let appStoreURL = self.version.appStoreURL else {
                    return
                }
                if UIApplication.shared.canOpenURL(appStoreURL) {
                    UIApplication.shared.open(appStoreURL)
                }
            } label: {
                Text("앱 업데이트")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            .padding()
            .background(.green, in: Capsule())
            .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
    
}

// MARK: - Preview

#Preview {
    VersionView()
}
