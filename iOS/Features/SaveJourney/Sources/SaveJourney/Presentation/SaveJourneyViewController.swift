//
//  SaveJourneyViewController.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import UIKit

public final class SaveJourneyViewController: UIViewController {
    
    typealias SaveJourneyDataSource = UICollectionViewDiffableDataSource
    
    // MARK: - Properties
    
    private let viewModel: SaveJourneyViewModel
    
    // MARK: - UI Components
    
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Initializer
    
    public init(viewModel: SaveJourneyViewModel,
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
    }
    
}

// MARK: - UI Configuration

private extension SaveJourneyViewController {
    
    func configureLayout() {
        self.view.addSubview(self.albumArtImageView)
        self.albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.albumArtImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.albumArtImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.albumArtImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.albumArtImageView.heightAnchor.constraint(equalTo: self.albumArtImageView.widthAnchor)
        ])
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    let saveJourneyViewModel = SaveJourneyViewModel()
    let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
    return saveJourneyViewController
}
