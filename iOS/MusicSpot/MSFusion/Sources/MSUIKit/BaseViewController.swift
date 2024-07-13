//
//  BaseViewController.swift
//  MSUIKit
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

import MSDesignSystem

open class BaseViewController: UIViewController {

    // MARK: Open

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureSafeArea()
        configureStyle()
        configureLayout()
    }

    /// CornerRadius, 색상 등의 변경을 포함합니다.
    open func configureStyle() {
        view.backgroundColor = .msColor(.primaryBackground)
    }

    /// addSubView, Auto Layout 등의 레이아웃 설정을 포함합니다.
    open func configureLayout() { }

    // MARK: Private

    private func configureSafeArea() {
        let safeAreaInsets = UIEdgeInsets(
            top: 24.0,
            left: 16.0,
            bottom: 24.0,
            right: 16.0)
        additionalSafeAreaInsets = safeAreaInsets
    }
}
