//
//  SelectSongViewController.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.03.
//

import UIKit

import MSUIKit

public final class SelectSongViewController: BaseViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let title = "음악 검색"
        
    }
    
    private enum Metric {
        
        static let searchTextFieldBottomSpacing: CGFloat = 16.0
        
    }
    
    // MARK: - UI Components
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        return collectionView
    }()
    
    private let searchTextField: MSTextField = {
        let textField = MSTextField()
        textField.imageStyle = .search
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        return textField
    }()
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    // MARK: - UI Configuration
    
    public override func configureStyle() {
        super.configureStyle()
        
        self.title = Typo.title
    }
    
    public override func configureLayout() {
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.view.addSubview(self.searchTextField)
        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.searchTextField.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor,
                                                         constant: -Metric.searchTextFieldBottomSpacing),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

// MARK: - Preview

#if DEBUG
import MSDesignSystem

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    
    let selectSongViewController = SelectSongViewController()
    return selectSongViewController
}
#endif
