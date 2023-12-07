//
//  JourneyListViewController.swift
//  JourneyList
//
//  Created by 이창준 on 11/22/23.
//

import Combine
import UIKit

import MSCacheStorage
import MSDomain
import MSUIKit

public final class JourneyListViewController: BaseViewController {
    
    typealias JourneyListDataSource = UICollectionViewDiffableDataSource<Int, Journey>
    typealias JourneyListHeaderRegistration = UICollectionView.SupplementaryRegistration<JourneyListHeaderView>
    typealias JourneyCellRegistration = UICollectionView.CellRegistration<JourneyCell, Journey>
    typealias JourneySnapshot = NSDiffableDataSourceSnapshot<Int, Journey>
    
    // MARK: - Constants
    
    private enum Typo {
        
        static func subtitle(numberOfJourneys: Int) -> String {
            return "현재 위치에 \(numberOfJourneys)개의 여정이 있습니다."
        }
        
    }
    
    private enum Metric {
        
        static let collectionViewHorizontalInset: CGFloat = 10.0
        static let collectionViewVerticalInset: CGFloat = 24.0
        static let interGroupSpacing: CGFloat = 12.0
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: JourneyListNavigationDelegate?
    
    private let cache: MSCacheStorage
    
    private var viewModel: JourneyListViewModel
    
    private var dataSource: JourneyListDataSource?
    
    private var currentSnapshot: JourneySnapshot? {
        return self.dataSource?.snapshot()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private lazy var collectionView: MSCollectionView = {
        let collectionView = MSCollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Initializer
    
    public init(viewModel: JourneyListViewModel,
                cache: MSCacheStorage = MSCacheStorage(),
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        self.cache = cache
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyle()
        self.configureLayout()
        self.configureCollectionView()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    // MARK: - Combine Binding
    
    func bind() {
        self.viewModel.state.journeys
            .receive(on: DispatchQueue.main)
            .sink { journeys in
                var snapshot = JourneySnapshot()
                snapshot.appendSections([.zero])
                snapshot.appendItems(journeys, toSection: .zero)
                self.dataSource?.apply(snapshot)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions
    
    public func fetchJourneys(from coordinates: (Coordinate, Coordinate)) {
        self.viewModel.trigger(.fetchJourney(at: coordinates))
    }
    
    // MARK: - UI Configuration
    
    public override func configureStyle() {
        super.configureStyle()
        self.view.backgroundColor = .msColor(.primaryBackground)
    }
    
    public override func configureLayout() {
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let bottomAnchor = self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomAnchor.priority = .defaultLow
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: Metric.collectionViewHorizontalInset),
            bottomAnchor,
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                          constant: -Metric.collectionViewHorizontalInset)
        ])
    }
    
}

// MARK: - CollectionView

extension JourneyListViewController: UICollectionViewDelegate {
    
    private func configureCollectionView() {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(JourneyListHeaderView.estimatedHight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.pinToVisibleBounds = true
        configuration.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return self.configureSection()
        }, configuration: configuration)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    private func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(JourneyCell.estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.interGroupSpacing
        
        return section
    }
    
    private func fetchImage(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else {
            throw NSError(domain: "fetch error", code: 1004)
        }
        
        return data
    }
    
    private func configureDataSource() -> JourneyListDataSource {
        // TODO: 최적화 & 캐싱
        let cellRegistration = JourneyCellRegistration { cell, indexPath, itemIdentifier in
            let cellModel = JourneyCellModel(location: itemIdentifier.title,
                                             date: itemIdentifier.date.start,
                                             songTitle: itemIdentifier.music.title,
                                             songArtist: itemIdentifier.music.artist)
            cell.update(with: cellModel)
            let photoURLs = itemIdentifier.spots
                .map { $0.photoURL }
            
            cell.updateImages(with: photoURLs, for: indexPath)
        }
        
        let headerRegistration = JourneyListHeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader,
                                                               handler: { header, _, indexPath in
            
        })
      
        let dataSource = JourneyListDataSource(collectionView: self.collectionView,
                                               cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        })
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
        
        return dataSource
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        self.navigationDelegate?.navigateToRewindJourney()
    }
    
}

// MARK: - Preview

#if DEBUG
import MSData
import MSDesignSystem
import MSNetworking
@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let journeyRepository = JourneyRepositoryImplementation()
    let testViewModel = JourneyListViewModel(repository: journeyRepository)
    let testViewController = JourneyListViewController(viewModel: testViewModel)
    return testViewController
}
#endif
