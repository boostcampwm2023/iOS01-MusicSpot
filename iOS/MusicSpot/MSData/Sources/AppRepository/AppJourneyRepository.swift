//
//  AppJourneyRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/4/24.
//

import Foundation
import SwiftData

import DataSource
import Entity
import MSError
import Repository

public final class AppJourneyRepository: JourneyRepository {
    // MARK: - Properties

    private let context: ModelContext

    // MARK: - Initializer

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Functions

    public func fetchJourneys(in region: Region) async throws -> [Journey] {
        let (rectMinX, rectMaxX) = (region.origin.x, region.origin.x + region.width)
        let (rectMinY, rectMaxY) = (region.origin.y, region.origin.y + region.height)
        
        let predicate = #Predicate<JourneyLocalDataSource> { dataSource in
            return dataSource.coordinates.contains { coordinate in
                return (coordinate.x >= rectMinX) && (coordinate.x <= rectMaxX) && (coordinate.y >= rectMinY) && (coordinate.y <= rectMaxY)
            }
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)
        
        let result = try self.context.fetch(consume descriptor)
        
        return result.map { $0.toEntity() }
    }

    public func fetchTravelingJourney() async throws -> Journey {
        let predicate = #Predicate<JourneyLocalDataSource> { journey in
            return journey.isTraveling
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)
        
        let results = try self.context.fetch(consume descriptor)

        // TODO: 진행 중인 여정이 여러개 일 때 부가 처리
        guard results.count == 1 else {
            throw JourneyError.multipleTravelingJourneys
        }

        guard let result = results.first else {
            throw JourneyError.multipleTravelingJourneys
        }

        return result.toEntity()
    }

    @discardableResult
    public func updateJourney(_ journey: Journey) async throws -> Journey {
        do {
            let id = journey.id
            let predicate = #Predicate<JourneyLocalDataSource> { dataSource in
                return dataSource.journeyID == consume id
            }
            let descriptor = FetchDescriptor(predicate: consume predicate)

            let fetchedValues = try self.context.fetch(consume descriptor, batchSize: 1)
            guard let targetJourney = fetchedValues.first else {
                throw JourneyError.noTravelingJourney
            }
            
            // Journey가 존재할 경우 targetJourney를 주어진 journey 값으로 업데이트
            targetJourney.update(to: journey)
        } catch JourneyError.noTravelingJourney {
            // Journey가 없을 경우 새로 생성
            self.context.insert(JourneyLocalDataSource(from: journey))
        } catch {
            throw error
        }

        guard self.context.hasChanges else {
            throw JourneyError.noLocalUpdate
        }
        
        do {
            try self.context.save()
            return journey
        } catch {
            throw JourneyError.repositoryError(error)
        }
    }

    @discardableResult
    // TODO: SwiftLint Swift 6 적용 후 삭제
    // swiftlint:disable:next identifier_name
    public func deleteJourney(_ journey: Journey) async throws -> Journey {
        let id = journey.id
        let predicate = #Predicate<JourneyLocalDataSource> { dataSource in
            return dataSource.journeyID == id
        }
        
        do {
            try self.context.delete(model: JourneyLocalDataSource.self, where: consume predicate)
            return journey
        } catch {
            throw error
        }
    }
}
