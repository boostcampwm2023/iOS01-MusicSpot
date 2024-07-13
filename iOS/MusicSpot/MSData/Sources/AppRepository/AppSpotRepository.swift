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

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: Public

    // MARK: - Functions

    public func addSpot(_ spot: Spot, to journey: Journey) throws {
        let id = journey.id
        let predicate = #Predicate<JourneyLocalDataSource> { dataSource in
            return dataSource.journeyID == consume id
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)

        let fetchedValues = try context.fetch(consume descriptor)

        guard let targetJourney = fetchedValues.first else {
            throw JourneyError.noTravelingJourney
        }

        targetJourney.spots.append(SpotLocalDataSource(from: spot))

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw SpotError.repositoryError(error)
            }
        }
    }

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

            return (spot: spot, photoData: photoData)
        }.makeAsyncIterator()

        return AsyncThrowingStream {
            try await stream.next()
        }
    }

    // MARK: Private

    // MARK: - Properties

    private let context: ModelContext

}
