//
//  MSTextField.swift
//  MSUIKit
//
//  Created by 전민건 on 11/14/23.
//

import UIKit

import MSDesignSystem

public class MSTextField: UITextField {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let height: CGFloat = 50.0
        static let leftInset: CGFloat = 22.0
        static let rightInset: CGFloat = 12.0
        static let verticalEdgeInsets: CGFloat = 10.0
        static let imageWidth: CGFloat = 20.0
        static let imageHeight: CGFloat = 20.0
        static let imageInset: CGFloat = 12.0
        static let cornerRadius: CGFloat = 8.0
        
    }
    
    private enum ImageBox {
        
        static let magnifyingglass = UIImage(systemName: "magnifyingglass")
        static let close = UIImage(systemName: "multiply.circle.fill")
        
    }
    
    public enum ImageStyle {
        
        case none
        case search
        case pin
        case calender
        case lock
        
        var leftImage: UIImage? {
            switch self {
            case .none:
                return nil
            case .search:
                return ImageBox.magnifyingglass
            case .pin:
                return .msIcon(.location)
            case .calender:
                return .msIcon(.calendar)
            case .lock:
                return .msIcon(.lock)
            }
        }
        var rightImage: UIImage? {
            switch self {
            case .none:
                return nil
            default:
                return .msIcon(.arrowRight)
            }
        }
        
    }
    //
    //    // MARK: - Properties
    //
    private var leftImage = UIImageView()
    private var rightImage = UIImageView()
    public var imageStyle: ImageStyle = .none {
        didSet {
            self.configureImageStyle()
            self.configureLayout()
        }
    }
    public override var text: String? {
        didSet {
            self.convertMode()
        }
    }
    //
    //    // MARK: - Initializer
    //
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    //
    //    // MARK: - UI Configuration
    //
    private func configureStyles() {
        self.font = .msFont(.caption)
        self.layer.cornerRadius = Metric.cornerRadius
        self.backgroundColor = .msColor(.primaryBackground)
        
        self.configureImageStyle()
    }
    
    private func configureLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
        placeholderConfigureLayout()
        
        self.addSubview(leftImage)
        self.addSubview(rightImage)
        
        leftImageConfigureLayout()
        rightImageConfigureLayout()
    }
    
    private func placeholderConfigureLayout() {
        leftPlaceholderConfigureLayout()
        rightPlaceholderConfigureLayout()
    }
    
    private func leftPlaceholderConfigureLayout() {
        let extraInset: CGFloat = self.imageStyle == .none ? 0.0 : Metric.imageWidth + Metric.imageInset
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Metric.leftInset + extraInset, height: 0.0))
        self.leftViewMode = .always
    }
    
    private func rightPlaceholderConfigureLayout() {
        let extraInset: CGFloat = self.hasText ? Metric.imageWidth + Metric.imageInset : 0.0
        self.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Metric.rightInset + extraInset, height: 0.0))
        self.rightViewMode = .always
    }
    
    private func leftImageConfigureLayout() {
        print(self.subviews)
        self.leftImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.leftInset),
            leftImage.heightAnchor.constraint(equalToConstant: Metric.imageHeight),
            leftImage.widthAnchor.constraint(equalToConstant: Metric.imageWidth),
            leftImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func rightImageConfigureLayout() {
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metric.imageInset),
            rightImage.heightAnchor.constraint(equalToConstant: Metric.imageHeight),
            rightImage.widthAnchor.constraint(equalToConstant: Metric.imageWidth),
            rightImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}

// MARK: - Edit/Non-Edit Mode Functions

public extension MSTextField {
    
    func convertMode() {
        configureRightImageStyle()
        rightImageConfigureLayout()
    }
    
}

// MARK: - Private Configuration Functions

private extension MSTextField {
    
    private func configureImageStyle() {
        configureLeftImageStyle()
        configureRightImageStyle()
    }
    
    private func configureLeftImageStyle() {
        if let leftImage = self.imageStyle.leftImage {
            self.leftImage.image = leftImage
        }
        self.leftImage.tintColor = .msColor(.secondaryTypo)
    }
    
    private func configureRightImageStyle() {
        if let rightImage = self.imageStyle.rightImage {
            self.rightImage.image = rightImage
        }
        
        if self.hasText {
            self.rightImage.image = ImageBox.close
        }
        self.rightImage.tintColor = .msColor(.secondaryTypo)
    }
    
    private func configureImages(color: UIColor) {
        leftImage.tintColor = color
        rightImage.tintColor = color
    }
    
}
