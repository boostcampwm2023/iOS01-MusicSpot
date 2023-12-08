//
//  MSButton+Primary.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

extension MSButton {
    
    public static func primary(isBrandColored: Bool = true) -> MSButton {
        let button = MSButton()
        let haptic = UINotificationFeedbackGenerator()
        defer { button.haptic = haptic }
        
        button.configuration?.baseForegroundColor = .msColor(.primaryButtonTypo)
        button.configuration?.baseBackgroundColor = isBrandColored
        ? .msColor(.musicSpot)
        : .msColor(.primaryButtonBackground)
        
        haptic.prepare()
        button.configurationUpdateHandler = { primaryButton in
            switch primaryButton.state {
            case .highlighted:
                haptic.notificationOccurred(.warning)
            default:
                break
            }
        }
        
        return button
    }
    
}
