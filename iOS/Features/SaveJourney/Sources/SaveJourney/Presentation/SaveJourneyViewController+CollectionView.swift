//
//  SaveJourneyViewController+CollectionView.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.08.
//

import CoreLocation
import UIKit

import MSLogger

// MARK: - Collection View

extension SaveJourneyViewController {
    
    // MARK: - Constants
    
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
    
    // MARK: - Configuration: CollectionView
    
    func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            guard let section = self.dataSource?.sectionIdentifier(for: sectionIndex) else { return .none }
            return self.configureSection(for: section)
        })
        layout.register(SaveJourneyBackgroundView.self,
                        forDecorationViewOfKind: SaveJourneyBackgroundView.elementKind)
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        let dataSource = self.configureDataSource()
        self.setDataSource(dataSource)
    }
    
    func configureSection(for section: SaveJourneySection) -> NSCollectionLayoutSection {
        let layoutItem = NSCollectionLayoutItem(layoutSize: section.itemSize)
        
        let itemCount = section == .music ? 1 : 2
        let interItemSpacing: CGFloat = section == .music ? .zero : Metric.innerSpacing
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: section.groupSize,
                                                       item: layoutItem,
                                                       count: itemCount)
        layoutGroup.interItemSpacing = .fixed(interItemSpacing)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = Metric.innerSpacing
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: Metric.verticalInset,
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
        if section != .empty {
            layoutSection.boundarySupplementaryItems = [header]
        }
        
        let backgroundView = NSCollectionLayoutDecorationItem.background(
            elementKind: SaveJourneyBackgroundView.elementKind)
        layoutSection.decorationItems = [backgroundView]
        
        return layoutSection
    }
    
    func configureDataSource() -> SaveJourneyDataSource {
        let musicCellRegistration = MusicCellRegistration { cell, _, itemIdentifier in
            cell.update(with: itemIdentifier)
        }
        
        let spotCellRegistration = SpotCellRegistration { cell, _, itemIdentifier in
            Task {
                let location = try await itemIdentifier.locationFromSpotCoordinates()
                
                let cellModel = SpotCellModel(location: location,
                                              date: itemIdentifier.timestamp,
                                              photoURL: itemIdentifier.photoURL)
                cell.update(with: cellModel)
            }
        }
        
        let emptyCellRegistration = EmptyCellRegistration { _, _, _ in }
        
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
            case .spot(let spot):
                return collectionView.dequeueConfiguredReusableCell(using: spotCellRegistration,
                                                                    for: indexPath,
                                                                    item: spot)
            case .empty:
                return collectionView.dequeueConfiguredReusableCell(using: emptyCellRegistration,
                                                                    for: indexPath,
                                                                    item: UUID())
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                         for: indexPath)
        }
        
        var snapshot = SaveJourneySnapshot()
        snapshot.appendSections([.music, .spot, .empty])
        dataSource.apply(snapshot)
        
        return dataSource
    }
    
}

// MARK: - CollectionView Scroll

extension SaveJourneyViewController: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: 맵 UX 개선
//        let offset = scrollView.contentOffset
//        self.updateMapViewSize(by: offset)
    }
    
    private func updateMapViewSize(by offset: CGPoint) {
        let beginStretchingOffset = -self.view.frame.width
        
        self.mapViewHeightConstraint?.constant = self.view.frame.width
        if offset.y < beginStretchingOffset {
            let stretchingSize = offset.y.magnitude - self.view.frame.width
            #if DEBUG
            MSLogger.make(category: .uiKit).debug("MapView should stretch for: \(stretchingSize)")
            #endif
            
            self.mapViewHeightConstraint?.constant += stretchingSize
        }
        
        #if DEBUG
        let constraint = self.mapViewHeightConstraint?.constant
        print(self.mapView.frame.height)
        MSLogger.make(category: .uiKit).debug("\(constraint!)")
        #endif
        self.view.layoutIfNeeded()
    }
    
}

// MARK: - Extension: Spot

import MSDomain

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
