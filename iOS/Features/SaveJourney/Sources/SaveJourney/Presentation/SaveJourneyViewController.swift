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
    case music
    case spot
}

enum SaveJourneyItem: Hashable {
    case music(String)
    case spot(Journey)
}

public final class SaveJourneyViewController: UIViewController {
    
    typealias SaveJourneyDataSource = UICollectionViewDiffableDataSource<SaveJourneySection, SaveJourneyItem>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SaveJourneyHeaderView>
    typealias MusicCellRegistration = UICollectionView.CellRegistration<SaveJourneyMusicCell, String>
    typealias JourneyCellRegistration = UICollectionView.CellRegistration<JourneyCell, Journey>
    typealias SaveJourneySnapshot = NSDiffableDataSourceSnapshot<SaveJourneySection, SaveJourneyItem>
    typealias MusicSnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    typealias SpotSnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    
    // MARK: - Constants
    
    private enum Metric {
        static let horizontalInset: CGFloat = 24.0
        static let verticalInset: CGFloat = 12.0
        static let innerGroupSpacing: CGFloat = 12.0
        static let headerTopInset: CGFloat = 24.0
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
        collectionView.contentInset = UIEdgeInsets(top: self.view.frame.width,
                                                   left: .zero,
                                                   bottom: .zero,
                                                   right: .zero)
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
                var snapshot = MusicSnapshot()
                snapshot.append([.music(music)])
                self.dataSource?.apply(snapshot, to: .music)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.journeys
            .sink { journeys in
                var snapshot = SpotSnapshot()
                snapshot.append(journeys.map { .spot($0) })
                self.dataSource?.apply(snapshot, to: .spot)
            }
            .store(in: &self.cancellables)
    }
    
}

// MARK: - Collection View

private extension SaveJourneyViewController {
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = self.dataSource?.sectionIdentifier(for: sectionIndex) else { return .none }
            return self.configureSection(for: section)
        })
        layout.register(SaveJourneyBackgroundView.self,
                        forDecorationViewOfKind: SaveJourneyBackgroundView.elementKind)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    func configureSection(for section: SaveJourneySection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupHeight: NSCollectionLayoutDimension = switch section {
        case .music: .estimated(SaveJourneyMusicCell.estimatedHeight)
        case .spot: .estimated(JourneyCell.estimatedHeight)
        }
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.innerGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.verticalInset,
                                                        leading: Metric.horizontalInset,
                                                        bottom: Metric.verticalInset,
                                                        trailing: Metric.horizontalInset)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(SaveJourneyHeaderView.estimatedHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SaveJourneyHeaderView.elementKind,
                                                                 alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: -Metric.headerTopInset,
                                                       leading: .zero,
                                                       bottom: .zero,
                                                       trailing: .zero)
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
            cell.update(with: "여정")
        }
        
        let headerRegistration = HeaderRegistration(elementKind: SaveJourneyHeaderView.elementKind,
                                                    handler: { header, _, indexPath in
            header.update(with: "헤더")
        })
        
        let dataSource = SaveJourneyDataSource(collectionView: self.collectionView,
                                               cellProvider: { collectionView, indexPath, item in
            switch item {
            case .music(let music):
                return collectionView.dequeueConfiguredReusableCell(using: musicCellRegistration,
                                                                    for: indexPath,
                                                                    item: music)
            case .spot(let journey):
                return collectionView.dequeueConfiguredReusableCell(using: journeyCellRegistration,
                                                                    for: indexPath,
                                                                    item: journey)
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
        
        var snapshot = SaveJourneySnapshot()
        snapshot.appendSections([.music, .spot])
        dataSource.apply(snapshot)
        
        return dataSource
    }
    
}

// MARK: - CollectionView Scroll

extension SaveJourneyViewController: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.updateProfileViewLayout(by: offset, name: "Change Me!")
    }
    
    func updateProfileViewLayout(by offset: CGPoint, name: String) {
        let collectionViewHeight = self.collectionView.frame.height
        let collectionViewContentInset = collectionViewHeight - self.view.safeAreaInsets.top
        let assistanceValue = collectionViewHeight - collectionViewContentInset
        let isContentBelowTopOfScreen = offset.y < 0
        
        if isContentBelowTopOfScreen {
            self.navigationItem.title = nil
            self.mapViewHeightConstraint?.constant = assistanceValue + offset.y.magnitude
        } else if !isContentBelowTopOfScreen {
            self.navigationItem.title = name
            self.mapViewHeightConstraint?.constant = 0
        } else {
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
