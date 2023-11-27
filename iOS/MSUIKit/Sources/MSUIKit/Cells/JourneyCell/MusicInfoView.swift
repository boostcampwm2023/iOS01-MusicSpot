//
//  MusicInfoView.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

final class MusicInfoView: UIView {
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let musicInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msIcon(.voice)
        imageView.tintColor = .msColor(.primaryTypo)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.boldCaption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Title"
        return label
    }()
    
    private let dividerLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "・"
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Artist"
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    func update(artist: String, title: String) {
        self.artistLabel.text = artist
        self.titleLabel.text = title
    }
    
}

// MARK: - UI Configuration

private extension MusicInfoView {
    
    func configureLayout() {
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        [
            Spacer(.horizontal),
            self.iconImageView,
            self.musicInfoStackView
        ].forEach {
            self.stackView.addArrangedSubview($0)
        }
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.iconImageView.widthAnchor.constraint(equalToConstant: 24.0),
            self.iconImageView.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        [
            self.titleLabel,
            self.dividerLabel,
            self.artistLabel
        ].forEach {
            self.musicInfoStackView.addArrangedSubview($0)
        }
    }
    
}

// MARK: - Preview

import MSDesignSystem
@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 341.0, height: 24.0)) {
    MSFont.registerFonts()
    let musicInfoView = MusicInfoView()
    return musicInfoView
}
