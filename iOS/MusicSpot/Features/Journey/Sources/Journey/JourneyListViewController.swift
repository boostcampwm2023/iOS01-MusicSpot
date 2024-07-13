//
//  JourneyListViewController.swift
//  Journey
//
//  Created by 이창준 on 11/22/23.
//

import Combine
import UIKit

import Entity
import MSUIKit

// MARK: - JourneyListViewController

public final class JourneyListViewController: BaseViewController {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        viewModel: JourneyListViewModel,
        nibName nibNameOrNil: String? = nil,
        bundle nibBundleOrNil: Bundle? = nil)
    {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Public

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        configureLayout()
        configureCollectionView()
        bind()
    }

    // MARK: - UI Configuration

    public override func configureStyle() {
        super.configureStyle()
        view.backgroundColor = .msColor(.primaryBackground)
    }

    public override func configureLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomAnchor.priority = .defaultLow
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Metric.collectionViewHorizontalInset),
            bottomAnchor,
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Metric.collectionViewHorizontalInset),
        ])
    }

    // MARK: Internal

    typealias JourneyListDataSource = UICollectionViewDiffableDataSource<Int, Journey>
    typealias JourneyListHeaderRegistration = UICollectionView.SupplementaryRegistration<JourneyListHeaderView>
    typealias JourneyCellRegistration = UICollectionView.CellRegistration<JourneyCell, Journey>
    typealias JourneySnapshot = NSDiffableDataSourceSnapshot<Int, Journey>

    // MARK: - Properties

    private(set) var viewModel: JourneyListViewModel

    // MARK: Private

    // MARK: - Constants

    private enum Typo {
        static func subtitle(numberOfJourneys: Int) -> String {
            "현재 위치에 \(numberOfJourneys)개의 여정이 있습니다."
        }
    }

    private enum Metric {
        static let collectionViewHorizontalInset: CGFloat = 10.0
        static let collectionViewVerticalInset: CGFloat = 24.0
        static let interGroupSpacing: CGFloat = 12.0
    }

    private var dataSource: JourneyListDataSource?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()

    private var currentSnapshot: JourneySnapshot? {
        dataSource?.snapshot()
    }

    // MARK: - Combine Binding

    private func bind() {
        viewModel.state.journeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] journeys in
                guard let self else { return }

                let emptySnapshot = JourneySnapshot()
                dataSource?.apply(emptySnapshot, animatingDifferences: true)
                var snapshot = JourneySnapshot()
                snapshot.appendSections([.zero])
                snapshot.appendItems(journeys, toSection: .zero)
                dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }

}

// MARK: UICollectionViewDelegate

extension JourneyListViewController: UICollectionViewDelegate {

    // MARK: Public

    public func collectionView(
        _: UICollectionView,
        didSelectItemAt indexPath: IndexPath)
    {
        guard let journey = dataSource?.itemIdentifier(for: indexPath) else { return }

        let spotPhotoURLs = journey.spots.flatMap { $0.photoURLs }
//        self.navigationDelegate?.navigateToRewindJourney(with: spotPhotoURLs, music: journey.music)
    }

    // MARK: Private

    private func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            self.configureSection()
        }

        collectionView.setCollectionViewLayout(layout, animated: false)
        dataSource = configureDataSource()
    }

    private func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(JourneyCell.estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.interGroupSpacing

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(JourneyListHeaderView.estimatedHight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [header]

        return section
    }

    private func configureDataSource() -> JourneyListDataSource {
        let cellRegistration = JourneyCellRegistration { cell, indexPath, itemIdentifier in
            let cellModel = JourneyCellModel(
                location: itemIdentifier.title ?? "",
                date: itemIdentifier.date.start)
            cell.update(with: cellModel)
            let photoURLs = itemIdentifier.spots
                .flatMap { $0.photoURLs }

            cell.updateImages(with: photoURLs, for: indexPath)
        }

        let headerRegistration = JourneyListHeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader)
        { header, _, _ in
            guard let numberOfItems = self.currentSnapshot?.numberOfItems else { return }
            header.update(numberOfJourneys: numberOfItems)
        }

        let dataSource = JourneyListDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item)
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath)
        }

        return dataSource
    }

}
