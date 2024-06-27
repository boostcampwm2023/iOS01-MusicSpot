//
//  AppSpotRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/11/24.
//

import Foundation
import SwiftData

import DataSource
import Entity
import MSError
import MSImageFetcher
import Repository

public final class AppSpotRepository: SpotRepository {
    // MARK: - Properties

    private let context: ModelContext

    // MARK: - Initializer

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Functions

    public func addSpot(_ spot: Spot, to journey: Journey) throws {
        let targetJourney = try self.singleJourneyFromContext { dataSource in
            return dataSource.isEqual(to: journey)
        }

        targetJourney.spots.append(SpotLocalDataSource(from: spot))
        
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                throw SpotError.repositoryFailure(error)
            }
        }
    }
    
    // 이거 맞나....
    public func fetchPhotos(of spot: Spot) -> AsyncThrowingStream<PhotoWithSpot, Error> {
        var stream = AsyncStream<URL> { continuation in
            for photoURL in spot.photoURLs {
                continuation.yield(photoURL)
            }
            continuation.finish()
        }.map { photoURL in
            guard let photoData = await MSImageFetcher.shared.fetchImage(from: photoURL, forKey: photoURL.path()) else {
                throw ImageFetchError.imageFetchFailed
            }

            let photoWithSpot = (spot: spot, photoData: photoData)
            return photoWithSpot
        }.makeAsyncIterator()

        return AsyncThrowingStream {
            try await stream.next()
        }
    }
}

private extension AppSpotRepository {
    // TODO: Generic 사용한 SwiftData extension으로 추가
    func singleJourneyFromContext(matching predicate: @escaping (JourneyLocalDataSource) -> Bool) throws -> JourneyLocalDataSource {
        let predicate = #Predicate<JourneyLocalDataSource> { journey in
            return consume predicate(journey)
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)

        let fetchedValues = try self.context.fetch(consume descriptor, batchSize: 1)
        guard let result = fetchedValues.first else {
            throw JourneyError.emptyTravelingJourney
        }
        return result
    }
}
