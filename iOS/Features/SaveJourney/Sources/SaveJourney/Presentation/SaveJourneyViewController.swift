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
import MediaPlayer

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
    
    private enum Typo {
        
        static let songSectionTitle = "함께한 음악"
        static func spotSectionTitle(_ numberOfSpots: Int) -> String {
            return "\(numberOfSpots)개의 스팟"
        }
        static let nextButtonTitle = "다음"
        
    }
    
    private enum Metric {
        
        static let horizontalInset: CGFloat = 24.0
        static let verticalInset: CGFloat = 12.0
        static let innerGroupSpacing: CGFloat = 12.0
        static let headerTopInset: CGFloat = 24.0
        static let buttonSpacing: CGFloat = 4.0
        static let buttonBottomInset: CGFloat = 24.0
        
    }
    
    // MARK: - Properties
    
    private let viewModel: SaveJourneyViewModel
    
    private var dataSource: SaveJourneyDataSource?
    
    private let musicPlayer = MPMusicPlayerApplicationController.applicationMusicPlayer
    
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
    
    private let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.buttonSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let mediaControlButton: MSRectButton = {
        let button = MSRectButton.small()
        button.configuration?.image = .msIcon(.play)
        return button
    }()
    
    private lazy var nextButton: MSButton = {
        let button = MSButton.primary()
        button.configuration?.title = Typo.nextButtonTitle
        return button
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
        self.configureStyles()
        self.configureLayout()
        self.configureComponents()
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
            .receive(on: DispatchQueue.main)
            .sink { journeys in
                var snapshot = SpotSnapshot()
                snapshot.append(journeys.map { .spot($0) })
                self.dataSource?.apply(snapshot, to: .spot)
            }
            .store(in: &self.cancellables)
    }
    
}

// MARK: - Buttons

private extension SaveJourneyViewController {
    
    func configureButtons() {
        let mediaControlAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.mediaControlButtonDidTap)
        }
        self.mediaControlButton.addAction(mediaControlAction, for: .touchUpInside)
        
        let nextButtonAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.nextButtonDidTap)
            
            let alert = ConfirmTitleAlertViewController()
            alert.modalPresentationStyle = .overCurrentContext
            self?.present(alert, animated: false)
        }
        self.nextButton.addAction(nextButtonAction, for: .touchUpInside)
    }
    
}

// MARK: - Media Player

private extension SaveJourneyViewController {
    
    func configureMusicPlayer() {
        self.musicPlayer.setQueue(with: .songs())
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
        
        let journeyCellRegistration = JourneyCellRegistration { cell, indexPath, itemIdentifier in
            let cellModel = JourneyCellModel(location: itemIdentifier.location,
                                             date: itemIdentifier.date,
                                             songTitle: itemIdentifier.song.title,
                                             songArtist: itemIdentifier.song.artist)
            cell.update(with: cellModel)
            // TODO: ImageFetcher 사용해 이미지 업데이트
        }
        
        let headerRegistration = HeaderRegistration(elementKind: SaveJourneyHeaderView.elementKind,
                                                    handler: { header, _, indexPath in
            switch indexPath.section {
            case .zero:
                header.update(with: Typo.songSectionTitle)
            case 1:
                let spots = self.viewModel.state.journeys
                header.update(with: Typo.spotSectionTitle(spots.value.count))
            default:
                break
            }
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
        
        self.view.addSubview(self.buttonStack)
        self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buttonStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.buttonStack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.buttonStack.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor,
                                                     constant: -Metric.buttonBottomInset)
        ])
        
        [
            self.mediaControlButton,
            self.nextButton
        ].forEach {
            self.buttonStack.addArrangedSubview($0)
        }
    }
    
    func configureComponents() {
        self.configureCollectionView()
        self.configureButtons()
        self.configureMusicPlayer()
    }
    
}

// MARK: - Preview

#if DEBUG
import MSData

@available(iOS 17, *)
#Preview {
    let journeyRepository = JourneyRepositoryImplementation()
    let saveJourneyViewModel = SaveJourneyViewModel(repository: journeyRepository)
    let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
    return saveJourneyViewController
}
#endif
