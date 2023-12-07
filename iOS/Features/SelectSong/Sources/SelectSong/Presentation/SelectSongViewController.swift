//
//  SelectSongViewController.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.03.
//

import Combine
import MusicKit
import UIKit

import CombineCocoa
import MSDesignSystem
import MSDomain
import MSLogger
import MSUIKit

public final class SelectSongViewController: BaseViewController {
    
    typealias SongListDataSource = UICollectionViewDiffableDataSource<Int, Music>
    typealias SongListCellRegistration = UICollectionView.CellRegistration<SongListCell, Music>
    typealias SongListSnapshot = NSDiffableDataSourceSnapshot<Int, Music>
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let title = "음악 검색"
        static let searchTextFieldPlaceholder = "추가할 음악을 검색하세요."
        
    }
    
    private enum Metric {
        
        static let searchTextFieldBottomSpacing: CGFloat = 16.0
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: SelectSongNavigationDelegate?
    
    private let musicPlayer = ApplicationMusicPlayer.shared
    
    private let viewModel: SelectSongViewModel
    
    private var dataSource: SongListDataSource?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    private let searchTextField: MSTextField = {
        let textField = MSTextField()
        textField.imageStyle = .search
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        var container = AttributeContainer()
        container.font = .msFont(.caption)
        let attributedString = AttributedString(Typo.searchTextFieldPlaceholder, attributes: container)
        textField.attributedPlaceholder = NSAttributedString(attributedString)
        return textField
    }()
    
    // MARK: - Initializer
    
    public init(viewModel: SelectSongViewModel,
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
        self.configureCollectionView()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.searchTextField.textPublisher
            .filter { !$0.isEmpty }
            .print()
            .sink { text in
                self.viewModel.trigger(.searchTextFieldDidUpdate(text))
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.songs
            .receive(on: DispatchQueue.main)
            .sink { songs in
                var snapshot = SongListSnapshot()
                snapshot.appendSections([.zero])
                snapshot.appendItems(songs, toSection: .zero)
                self.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - UI Configuration
    
    public override func configureStyle() {
        super.configureStyle()
        
        self.title = Typo.title
        self.searchTextField.becomeFirstResponder()
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

// MARK: - CollectionView Configuration

private extension SelectSongViewController {
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return self.configureSection()
        })
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    private func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(SongListCell.estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureDataSource() -> SongListDataSource {
        let cellRegistration = SongListCellRegistration { cell, indexPath, itemIdentifier in
            let cellModel = SongListCellModel(title: itemIdentifier.title,
                                              artist: itemIdentifier.artist,
                                              albumArtURL: itemIdentifier.artwork.url)
            cell.update(with: cellModel)
        }
        
        let dataSource = SongListDataSource(collectionView: self.collectionView,
                                            cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        })
        
        return dataSource
    }
    
}

// MARK: - CollectionView

extension SelectSongViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        #if DEBUG
        MSLogger.make(category: .selectSong).log("\(item.title) selected")
        #endif
        
        // TODO: 실제 데이터 바인딩
        let artwork = Artwork(width: 52, height: 52,
                              url: URL(string: "")!,
                              backgroundColor: "", textColor1: "", textColor2: "", textColor3: "", textColor4: "")
        let music = Music(id: 23, title: "Super Shy", artist: "NewJeans", artwork: artwork)
        self.navigationDelegate?.navigateToSaveJourney(with: music)
    }
    
}

// MARK: - Preview

#if DEBUG
import MSData
import MSDesignSystem

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    
    let songRepository = SongRepositoryImplementation()
    let selectSongViewModel = SelectSongViewModel(repository: songRepository)
    let selectSongViewController = SelectSongViewController(viewModel: selectSongViewModel)
    return selectSongViewController
}
#endif
