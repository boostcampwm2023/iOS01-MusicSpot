//
//  SaveJourneyViewController+CollectionView.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.08.
//

import CoreLocation
import UIKit

// MARK: - Collection View

extension SaveJourneyViewController {
    
    private enum Typo {
        
        static let songSectionTitle = "함께한 음악"
        static func spotSectionTitle(_ numberOfSpots: Int) -> String {
            return "\(numberOfSpots)개의 스팟"
        }
        
    }
    
    private enum Metric {
        
        static let horizontalInset: CGFloat = 24.0
        static let verticalInset: CGFloat = 12.0
        static let innerSpacing: CGFloat = 4.0
        static let headerTopInset: CGFloat = 24.0
        
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = self.dataSource?.sectionIdentifier(for: sectionIndex) else { return .none }
            return self.configureSection(for: section)
        })
        layout.register(SaveJourneyBackgroundView.self,
                        forDecorationViewOfKind: SaveJourneyBackgroundView.elementKind)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.updateDataSource(self.configureDataSource())
    }
    
    func configureSection(for section: SaveJourneySection) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: section.itemSize)
        
        let itemCount = section == .music ? 1 : 2
        let interItemSpacing: CGFloat = section == .music ? .zero : Metric.innerSpacing
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: section.groupSize,
                                                       item: item,
                                                       count: itemCount)
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.innerSpacing
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
        
        let journeyCellRegistration = SpotCellRegistration { cell, _, itemIdentifier in
            Task {
                let location = try await itemIdentifier.locationFromSpotCoordinates()
                
                let cellModel = SpotCellModel(location: location,
                                              date: itemIdentifier.timestamp,
                                              photoURL: itemIdentifier.photoURL)
                cell.update(with: cellModel)
            }
        }
        
        let headerRegistration = HeaderRegistration(elementKind: SaveJourneyHeaderView.elementKind,
                                                    handler: { header, _, indexPath in
            switch indexPath.section {
            case .zero:
                header.update(with: Typo.songSectionTitle)
            case 1:
                guard let spots = self.viewModel.state.recordingJourney.value?.spots else { return }
                header.update(with: Typo.spotSectionTitle(spots.count))
            default:
                break
            }
        })
        
        let dataSource = SaveJourneyDataSource(collectionView: self.collectionView,
                                               cellProvider: { collectionView, indexPath, item in
            switch item {
            case .music(let song):
                return collectionView.dequeueConfiguredReusableCell(using: musicCellRegistration,
                                                                    for: indexPath,
                                                                    item: song)
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

import MSDomain

extension SaveJourneyViewController: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.updateProfileViewLayout(by: offset)
    }
    
    func updateProfileViewLayout(by offset: CGPoint) {
        let collectionViewHeight = self.collectionView.frame.height
        let collectionViewContentInset = collectionViewHeight - self.view.safeAreaInsets.top
        let assistanceValue = collectionViewHeight - collectionViewContentInset
        let isContentBelowTopOfScreen = offset.y < .zero
        
        if isContentBelowTopOfScreen {
            self.mapViewHeightConstraint?.constant = assistanceValue + offset.y.magnitude
        } else if !isContentBelowTopOfScreen {
            self.mapViewHeightConstraint?.constant = .zero
        } else {
            self.mapViewHeightConstraint?.constant = offset.y.magnitude
        }
    }
    
}

private extension Spot {
    
    func locationFromSpotCoordinates() async throws -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: self.coordinate.latitude,
                                  longitude: self.coordinate.longitude)
        
        do {
            let placemark = try await geocoder.reverseGeocodeLocation(location).first
            
            var addressComponents: [String] = []
            
            if let locality = placemark?.locality {
                addressComponents.append(locality)
            }
            
            if let subLocality = placemark?.subLocality {
                addressComponents.append(subLocality)
            }
            
            return addressComponents.joined(separator: " ")
        } catch {
            throw error
        }
    }
    
}
