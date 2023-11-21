//
//  MSTextField.swift
//  MSUIKit
//
//  Created by 전민건 on 11/14/23.
//

import UIKit

import MSDesignSystem

@available(iOS 17, *)
#Preview {
    let tf = UITextField()
    let color = UIColor.msColor(.secondaryButtonBackground)
//    let color = UIColor.black
    tf.backgroundColor = color
    return tf
}

public class MSTextField: UITextField {
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
//        self.backgroundColor = .msColor(.secondaryButtonBackground)
//        configureStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Constants
    
    private enum Metric {
        static let width: CGFloat = 30.0
        static let horizontalEdgeInsets: CGFloat = 58.0
        static let verticalEdgeInsets: CGFloat = 10.0
        static let imagePadding: CGFloat = 8.0
    }
//    
//    // MARK: - Properties
//    
//    public var title: String? {
////        didSet { self.configureTitle(self.title) }
//    }
//    
//    public var image: UIImage? {
////        didSet { self.configureIcon(self.image) }
//    }
//    
//    public var cornerStyle: CornerStyle = .squared {
////        didSet { self.configureCornerStyle(self.cornerStyle) }
//    }
//    
//    // MARK: - Initializer
//    
//    private override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.configureStyles()
//        self.configureLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
//    }
//    
//    // MARK: - UI Configuration
    private func configureStyles() {
        
        
//        self.configuration = configuration
    }
//    
//    private func configureLayout() {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: Metric.height)
//        ])
//    }
//    
//}
//
//// MARK: - Private Configuration Functions
//
//private extension MSButton {
//    
//    private func configureTitle(_ title: String?) {
//        var container = AttributeContainer()
//        container.font = .msFont(.buttonTitle)
//        self.configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
//    }
//    
//    private func configureIcon(_ icon: UIImage?) {
//        self.configuration?.image = icon
//    }
//    
//    private func configureCornerStyle(_ cornerStyle: CornerStyle) {
//        self.layer.cornerRadius = cornerStyle.cornerRadius
//        self.clipsToBounds = true
//    }
    
}
