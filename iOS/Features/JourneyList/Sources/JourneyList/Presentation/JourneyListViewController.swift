//
//  JourneyListViewController.swift
//  JourneyList
//
//  Created by 이창준 on 11/22/23.
//

import Combine
import UIKit

import MSDesignSystem

public final class JourneyListViewController: UIViewController {
    
    typealias JourneyListDataSource = UICollectionViewDiffableDataSource<Journey, String>
    typealias SpotPhotoCellRegistration = UICollectionView.CellRegistration<SpotPhotoCell, String>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<JourneyInfoHeaderView>
    typealias JourneySnapshot = NSDiffableDataSourceSnapshot<Journey, String>
    
    // MARK: - Constants
    
    private enum Typo {
        static let title: String = "지난 여정"
    }
    
    private enum Metric {
        static let titleStackSpacing: CGFloat = 4.0
        static let collectionViewHorizontalInset: CGFloat = 10.0
        static let collectionViewVerticalInset: CGFloat = 24.0
        static let interGroupSpacing: CGFloat = 5.0
        static let interSectionSpacing: CGFloat = 12.0
        static let headerSize: CGFloat = 93.0
        static let listHorizontalInset: CGFloat = 16.0
        static let listVerticalInset: CGFloat = 20.0
    }
    
    // MARK: - Properties
    
    private var viewModel: JourneyListViewModel
    
    private var dataSource: JourneyListDataSource?
    
    private var currentSnapshot: JourneySnapshot? {
        return self.dataSource?.snapshot()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.titleStackSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.headerTitle)
        label.textColor = .msColor(.primaryTypo)
        label.text = Typo.title
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.text = "현재 위치에 0개의 여정이 있습니다."
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: Metric.collectionViewVerticalInset / 2,
                                                   left: .zero,
                                                   bottom: Metric.collectionViewVerticalInset,
                                                   right: .zero)
        return collectionView
    }()
    
    // MARK: - Initializer
    
    public init(viewModel: JourneyListViewModel,
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
        self.configureStyle()
        self.configureLayout()
        self.configureCollectionView()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    func bind() {
        self.viewModel.state.journeys
            .sink { journeys in
                self.subtitleLabel.text = "현재 위치에 \(journeys.count)개의 여정이 있습니다."
                var snapshot = JourneySnapshot()
                snapshot.appendSections(journeys)
                journeys.forEach { journey in
                    snapshot.appendItems(journey.spot.images, toSection: journey)
                }
                self.dataSource?.apply(snapshot)
            }
            .store(in: &self.cancellables)
    }
    
}

// MARK: - CollectionView

private extension JourneyListViewController {
    
    func configureCollectionView() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Metric.interSectionSpacing
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return self.configureSection()
        }, configuration: config)
        layout.register(JourneyListBackgroundView.self,
                        forDecorationViewOfKind: JourneyListBackgroundView.reuseIdentifier)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(SpotPhotoCell.width),
                                               heightDimension: .absolute(SpotPhotoCell.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.interGroupSpacing
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.interGroupSpacing,
                                                        leading: Metric.listHorizontalInset,
                                                        bottom: Metric.listVerticalInset,
                                                        trailing: Metric.listHorizontalInset)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(Metric.headerSize))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let background = NSCollectionLayoutDecorationItem.background(
            elementKind: JourneyListBackgroundView.reuseIdentifier)
        section.decorationItems = [background]
        
        return section
    }
    
    func configureDataSource() -> JourneyListDataSource {
        let cellRegistration = SpotPhotoCellRegistration { cell, _, itemIdentifier in
            cell.update(with: itemIdentifier)
        }
        
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader,
                                                    handler: { header, _, indexPath in
            guard let journey = self.currentSnapshot?.sectionIdentifiers[indexPath.section] else {
                return
            }
            header.update(with: journey)
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
    
}

// MARK: - UI Configuration

private extension JourneyListViewController {
    
    func configureStyle() {
        self.view.backgroundColor = .msColor(.primaryBackground)
    }
    
    func configureLayout() {
        self.view.addSubview(self.titleStack)
        self.titleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.titleStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.titleStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.titleStack.addArrangedSubview(self.titleLabel)
        self.titleStack.addArrangedSubview(self.subtitleLabel)
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.titleStack.bottomAnchor,
                                                     constant: Metric.collectionViewVerticalInset / 2),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: Metric.collectionViewHorizontalInset),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                          constant: -Metric.collectionViewHorizontalInset)
        ])
    }
    
}

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let journeyListViewModel = JourneyListViewModel()
    let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
    return journeyListViewController
}
