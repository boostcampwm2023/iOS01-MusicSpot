//
//  MSButton+Secondary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.20.
//

import SwiftUI

import MSDesignSystem

fileprivate struct MSButtonSecondaryModifier: ViewModifier {
    
    // MARK: - Properties
    
    private let cornerStyle: MSButton.CornerStyle
    private let isBrandColored: Bool
    
    // MARK: - Initializer
    
    init(cornerStyle: MSButton.CornerStyle, isBrandColored: Bool) {
        self.cornerStyle = cornerStyle
        self.isBrandColored = isBrandColored
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.msColor(.secondaryButtonTypo))
            .background(
                RoundedRectangle(cornerRadius: self.cornerStyle.cornerRadius, style: .continuous)
                    .fill(Color.msColor(.secondaryButtonBackground))
            )
    }
    
}

extension MSButton {
    
    public func secondary(_ cornerStyle: CornerStyle = .squared,
                          isBrandColored: Bool = true) -> some View {
        self.modifier(MSButtonSecondaryModifier(cornerStyle: cornerStyle,
                                                isBrandColored: isBrandColored))
    }
    
}

#Preview("Rounded") {
    MSButton(title: "버튼", image: .msIcon(.check))
        .secondary(.rounded)
}

#Preview("Squared") {
    MSButton(title: "버튼", image: .msIcon(.check))
        .secondary(.squared)
}
