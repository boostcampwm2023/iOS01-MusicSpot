//
//  UITextField+Combine.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.03.
//

import Combine
import UIKit

public extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                                             object: self)

        return publisher
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
