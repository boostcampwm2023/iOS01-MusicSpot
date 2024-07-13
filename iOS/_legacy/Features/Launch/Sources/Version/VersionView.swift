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
        MusicSpot
        업데이트 안내
        """
        static let description = """
        보다 안정적이고 풍부한 여정을 위해
        앱을 업데이트 해주세요.
        """
        static let newFeatures = "✨ 새로운 기능"
        static let buttonTitle = "업데이트 하러가기"
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
        ZStack {
            VStack(alignment: .leading) {
                Image.msIcon(.logoWithTransparent)?
                    .renderingMode(.original)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 60.0)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 16.0) {
                Text(Typo.title)
                    .font(.msFont(.superTitle))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(Typo.description)
                    .font(.msFont(.subtitle))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let releaseNote = self.releaseNote {
                    VStack(spacing: 8.0) {
                        Text(Typo.newFeatures)
                            .font(.msFont(.boldCaption))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(releaseNote)
                            .font(.msFont(.caption))
                            .lineSpacing(5.0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 12.0)
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                Spacer()
                MSButton(title: Typo.buttonTitle) {
                    self.openAppStore()
                }
                .primary(.rounded)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .background(
            AngularGradient(
                gradient: Gradient(
                    colors: [
                        .msColor(.musicSpot),
                        .msColor(.primaryBackground)
                    ]),
                center: .topLeading,
                angle: .degrees(180 + 45)
            )
        )
    }
}

// MARK: - Functions: Privates

private extension VersionView {
    func openAppStore() {
        guard let appStoreURL = self.version.appStoreURL else {
            return
        }
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL)
        }
    }
}

// MARK: - Preview

import MSDesignSystem

#Preview {
    MSFont.registerFonts()
    let releaseNote = """
    1. 라디오 모드에서 발생하는 데이터 소모를 개선했습니다.
    2. 그 외 이전 버전에서 발생하는 문제를 수정했습니다.
    3. 이제 아이패드에서 시청할 수 있습니다.
    4. 익명으로 후원할 수 있는 옵션이 추가되었습니다.
    5. 새소식 탭 진입 시 알림 배지가 없어지도록 개선했습니다.
    6. 채팅창 관리가 편해지는 다양한 기능이 추가되었습니다.
    7. 크롬 캐스트를 지원합니다.
    """
    return VersionView(releaseNote: releaseNote)
}
