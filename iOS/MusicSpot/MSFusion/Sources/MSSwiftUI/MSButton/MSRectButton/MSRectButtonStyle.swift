//
//  MSRectButtonStyle.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/20/24.
//

import SwiftUI

public protocol MSRectButtonStyle: ButtonStyle {
    var scale: MSRectButtonScale { get set }
    var colorStyle: SecondaryColors { get set }
}
