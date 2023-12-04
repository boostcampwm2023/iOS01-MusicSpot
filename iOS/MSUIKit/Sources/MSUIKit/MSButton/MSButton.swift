//
//  MSButton.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

public class MSButton: UIButton {
    
    public enum CornerStyle {
        case squared
        case rounded
        case custom(CGFloat)
        
        var cornerRadius: CGFloat {
            switch self {
            case .squared: return 8.0
            case .rounded: return 25.0
            case .custom(let cornerRadius): return cornerRadius
            }
        }
        
    }
    
    // MARK: - Constants
    
    private enum Metric {
        static let height: CGFloat = 60.0
        static let horizontalEdgeInsets: CGFloat = 58.0
        static let verticalEdgeInsets: CGFloat = 10.0
        static let imagePadding: CGFloat = 8.0
    }
    
    // MARK: - Properties
    
    public var title: String? {
        didSet { self.configureTitle(self.title) }
    }
    
    public var image: UIImage? {
        didSet { self.configureIcon(self.image) }
    }
    
    public var cornerStyle: CornerStyle = .squared {
        didSet { self.configureCornerStyle(self.cornerStyle) }
    }
    
    // MARK: - Initializer
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureStyles() {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: Metric.verticalEdgeInsets,
                                                              leading: Metric.horizontalEdgeInsets,
                                                              bottom: Metric.verticalEdgeInsets,
                                                              trailing: Metric.horizontalEdgeInsets)
        configuration.imagePlacement = .leading
        configuration.imagePadding = Metric.imagePadding
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byTruncatingMiddle
        self.configuration = configuration
    }
    
    private func configureLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
    }
    
}

// MARK: - Private Configuration Functions

private extension MSButton {
    
    private func configureTitle(_ title: String?) {
        var container = AttributeContainer()
        container.font = .msFont(.buttonTitle)
        self.configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
    }
    
    private func configureIcon(_ icon: UIImage?) {
        self.configuration?.image = icon
    }
    
    private func configureCornerStyle(_ cornerStyle: CornerStyle) {
        self.layer.cornerRadius = cornerStyle.cornerRadius
        self.clipsToBounds = true
    }
    
}
