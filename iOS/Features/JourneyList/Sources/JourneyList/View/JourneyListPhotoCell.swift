//
//  JourneyListPhotoCell.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

final class JourneyListPhotoCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Metric {
        static let width: CGFloat = 120.0
        static let height: CGFloat = 150.0
        static let cornerRadius: CGFloat = 5.0
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyle()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
}

private extension JourneyListPhotoCell {
    
    func configureStyle() {
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Metric.width),
            self.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
        
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}

@available(iOS 17.0, *)
#Preview {
    let cell = JourneyListPhotoCell()
    return cell
}
