//
//  SaveJourneyViewController.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine
import MapKit
import UIKit

import MSUIKit

enum SaveJourneySection {
    case journey
    case spot
}

enum SaveJourneyItem: Hashable {
    case journey(Journey)
    case spot(String)
}

public final class SaveJourneyViewController: UIViewController {
    
    typealias SaveJourneyDataSource = UICollectionViewDiffableDataSource<SaveJourneySection, SaveJourneyItem>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SaveJourneyHeaderView>
    typealias MusicCellRegistration = UICollectionView.CellRegistration<SaveJourneyMusicCell, String>
    typealias JourneyCellRegistration = UICollectionView.CellRegistration<JourneyCell, Journey>
    typealias SaveJourneySnapshot = NSDiffableDataSourceSnapshot<SaveJourneySection, SaveJourneyItem>
    
    // MARK: - Constants
    
    private enum Metric {
        static let horizontalInset: CGFloat = 24.0
        static let verticalInset: CGFloat = 12.0
        static let headerHeight: CGFloat = 33.0
        static let innerGroupSpacing: CGFloat = 12.0
    }
    
    // MARK: - Properties
    
    private let viewModel: SaveJourneyViewModel
    
    private var dataSource: SaveJourneyDataSource?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    private var mapViewHeightConstraint: NSLayoutConstraint?
    
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
        self.configureStyles()
        self.configureLayout()
        self.configureCollectionView()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    // MARK: - Combine Binding
    
    func bind() {
        self.viewModel.state.music
            .sink { music in
                print(music)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.journeys
            .sink { journeys in
                var snapshot = SaveJourneySnapshot()
                snapshot.appendSections([.spot, .journey])
                snapshot.appendItems(journeys.map { .journey($0) }, toSection: .journey)
                self.dataSource?.apply(snapshot)
            }
            .store(in: &self.cancellables)
    }
    
}

// MARK: - Collection View

private extension SaveJourneyViewController {
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return self.configureSection()
        })
        layout.register(SaveJourneyBackgroundView.self,
                        forDecorationViewOfKind: SaveJourneyBackgroundView.elementKind)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(268.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.innerGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.verticalInset,
                                                        leading: Metric.horizontalInset,
                                                        bottom: Metric.verticalInset,
                                                        trailing: Metric.horizontalInset)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(Metric.headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let backgroundView = NSCollectionLayoutDecorationItem.background(
            elementKind: SaveJourneyBackgroundView.elementKind)
        section.decorationItems = [backgroundView]
        
        return section
    }
    
    func configureDataSource() -> SaveJourneyDataSource {
        let musicCellRegistration = MusicCellRegistration { cell, _, itemIdentifier in
            cell.update(with: itemIdentifier)
        }
        
        let journeyCellRegistration = JourneyCellRegistration { cell, _, itemIdentifier in
            cell.update(with: "skldfj")
        }
        
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader,
                                                    handler: { header, _, indexPath in
            
        })
        
        let dataSource = SaveJourneyDataSource(collectionView: self.collectionView,
                                               cellProvider: { collectionView, indexPath, item in
            switch item {
            case .spot(let music):
                return collectionView.dequeueConfiguredReusableCell(using: musicCellRegistration,
                                                                    for: indexPath,
                                                                    item: music)
            case .journey(let journey):
                return collectionView.dequeueConfiguredReusableCell(using: journeyCellRegistration,
                                                                    for: indexPath,
                                                                    item: journey)
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
        
        return dataSource
    }
    
}

// MARK: - CollectionView Scroll

extension SaveJourneyViewController: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.updateProfileViewLayout(by: offset, name: "dslkjf")
    }
    
    func updateProfileViewLayout(by offset: CGPoint, name: String) {
        let collectionViewHeight = self.collectionView.frame.height
        let collectionViewContentInset = collectionViewHeight - self.view.safeAreaInsets.top
        let assistanceValue = collectionViewHeight - collectionViewContentInset
        let isContentBelowTopOfScreen = offset.y < 0
        
        // 컨텐츠가 `ProfileView`의 최대 높이 범위(330) 안에 있는 경우
        // ProfileView의 높이 변화
        if isContentBelowTopOfScreen {
            self.navigationItem.title = nil
            self.mapViewHeightConstraint?.constant = assistanceValue + offset.y.magnitude
        }
        // 컨텐츠의 최상단(`GiftStatsHeader`)이 화면의 상단보다 위에 있는 경우
        // contentInset은 `.zero`로 고정하고 ProfileView는 숨겨짐
        else if !isContentBelowTopOfScreen {
            self.navigationItem.title = name
            self.mapViewHeightConstraint?.constant = 0
        }
        // 스크롤뷰가 허용 범위보다 더 스크롤 됐을 경우
        // ProfileView의 크기를 더 크게
        else {
            self.mapViewHeightConstraint?.constant = offset.y.magnitude
        }
    }
    
}

// MARK: - UI Configuration

private extension SaveJourneyViewController {
    
    func configureStyles() {
        self.view.backgroundColor = .msColor(.primaryBackground)
    }
    
    func configureLayout() {
        self.view.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.mapViewHeightConstraint = self.mapView.heightAnchor.constraint(equalTo: self.mapView.widthAnchor)
        self.mapViewHeightConstraint?.isActive = true
        
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
