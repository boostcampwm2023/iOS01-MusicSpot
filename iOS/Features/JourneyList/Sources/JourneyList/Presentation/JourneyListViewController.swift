//
//  JourneyListViewController.swift
//  JourneyList
//
//  Created by 이창준 on 11/22/23.
//

import UIKit

import MSDesignSystem

final class JourneyListViewController: UIViewController {
    
    typealias JourneyListDataSource = UICollectionViewDiffableDataSource<Journey, Spot>
    typealias SpotPhotoCellRegistration = UICollectionView.CellRegistration<SpotPhotoCell, Spot>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<JourneyInfoHeaderView>
    
    // MARK: - Constants
    
    private enum Typo {
        static let title: String = "지난 여정"
    }
    
    private enum Metric {
        static let titleStackSpacing: CGFloat = 4.0
    }
    
    // MARK: - Properties
    
    private var dataSource: JourneyListDataSource?
    
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Journey, Spot>? {
        return self.dataSource?.snapshot()
    }
    
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
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureCollectionView()
    }
    
}

// MARK: - CollectionView

private extension JourneyListViewController {
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            return self.configureSection()
        }
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.dataSource = self.configureDataSource()
    }
    
    func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(300.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func configureDataSource() -> JourneyListDataSource {
        let cellRegistration = SpotPhotoCellRegistration { cell, indexPath, itemIdentifier in
            cell.update(with: itemIdentifier.images[indexPath.item])
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
            self.collectionView.topAnchor.constraint(equalTo: self.titleStack.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let journeyListViewController = JourneyListViewController()
    return journeyListViewController
}
