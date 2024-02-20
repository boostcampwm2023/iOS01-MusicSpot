//
//  Spacer.swift
//  MSUIKit
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

public final class Spacer: UIView {
    
    private override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    public convenience init(_ axis: NSLayoutConstraint.Axis) {
        self.init()
        setContentHuggingPriority(.defaultLow, for: axis)
        backgroundColor = .clear
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
