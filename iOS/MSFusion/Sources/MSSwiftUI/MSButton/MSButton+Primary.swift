//
//  MSButton+Primary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.19.
//

import SwiftUI

fileprivate struct MSButtonPrimaryModifier: ViewModifier {
    
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
        let backgroundColor: Color = self.isBrandColored
        ? .msColor(.musicSpot)
        : .msColor(.primaryButtonBackground)
        
        content
            .foregroundStyle(Color.msColor(.primaryButtonTypo))
            .background(
                RoundedRectangle(cornerRadius: self.cornerStyle.cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
    }
    
}

extension MSButton {
    
    public func primary(_ cornerStyle: CornerStyle = .squared,
                        isBrandColored: Bool = true) -> some View {
        self.modifier(MSButtonPrimaryModifier(cornerStyle: cornerStyle,
                                              isBrandColored: isBrandColored))
    }
    
}

#Preview("Rounded") {
    MSButton(title: "버튼", image: .msIcon(.check))
        .primary(.rounded)
}

#Preview("Squared") {
    MSButton(title: "버튼", image: .msIcon(.check))
        .primary(.squared)
}
