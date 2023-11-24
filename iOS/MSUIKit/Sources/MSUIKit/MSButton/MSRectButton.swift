//
//  MSRectButton.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

public final class MSRectButton: UIButton {
    
    internal enum Style {
        case small
        case large
        
        var size: CGSize {
            switch self {
            case .small: return CGSize(width: 52.0, height: 56.0)
            case .large: return CGSize(width: 120.0, height: 120.0)
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8.0
            case .large: return 30.0
            }
        }
        
    }
    
    // MARK: - Constants
    
    private enum Metric {
        static let edgeInsets: CGFloat = 10.0
    }
    
    // MARK: - Properties
    
    public var title: String? {
        didSet { self.configureTitle(self.title) }
    }
    
    public var image: UIImage? {
        didSet { self.configureIcon(self.image) }
    }
    
    internal var style: Style = .small {
        didSet {
            self.configureSize(by: self.style)
            self.configureCornerStyle(by: self.style)
        }
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
        configuration.baseForegroundColor = .msColor(.primaryTypo)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: Metric.edgeInsets,
                                                              leading: Metric.edgeInsets,
                                                              bottom: Metric.edgeInsets,
                                                              trailing: Metric.edgeInsets)
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .center
        self.configuration = configuration
    }
    
    private func configureLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

// MARK: - Private Configuration Functions

private extension MSRectButton {
    
    private func configureTitle(_ title: String?) {
        self.configuration?.image = nil
        var container = AttributeContainer()
        container.font = self.style == .large ? .msFont(.duperTitle) : .msFont(.buttonTitle)
        self.configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
    }
    
    private func configureIcon(_ icon: UIImage?) {
        self.configuration?.attributedTitle = nil
        self.configuration?.image = icon
    }
    
    private func configureSize(by style: Style) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: style.size.width),
            self.heightAnchor.constraint(equalToConstant: style.size.height)
        ])
    }
    
    private func configureCornerStyle(by style: Style) {
        self.layer.cornerRadius = style.cornerRadius
        self.clipsToBounds = true
    }
    
}
