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
        let result = try self.journeysFromContext { journey in
            return region.containsAny(of: journey.coordinates)
        }
        return result.map { $0.toEntity() }
    }

    public func fetchTravelingJourney() async throws -> Journey {
        let results = try? self.journeysFromContext { journey in
            return journey.isTraveling
        }

        // TODO: 진행 중인 여정이 여러개 일 때 부가 처리
        guard results?.count == 1 else {
            throw JourneyError.multipleTravelingJourneys
        }

        guard let result = results?.first else {
            throw JourneyError.multipleTravelingJourneys
        }

        return result.toEntity()
    }

    @discardableResult
    public func updateJourney(_ journey: Journey) async throws -> Journey {
        do {
            var targetJourney = try self.singleJourneyFromContext { dataSource in
                return dataSource.isEqual(to: journey)
            }
            
            // Journey가 존재할 경우 targetJourney를 주어진 journey 값으로 업데이트
            targetJourney.update(to: journey)
        } catch JourneyError.emptyTravelingJourney {
            // Journey가 없을 경우 새로 생성
            self.context.insert(JourneyLocalDataSource(from: journey))
        } catch {
            throw error
        }

        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                throw JourneyError.failedContextTransaction(error.localizedDescription)
            }
        }
    }

    @discardableResult
    // TODO: SwiftLint Swift 6 적용 후 삭제
    // swiftlint:disable:next identifier_name
    public func deleteJourney(_ journey: Journey) async throws -> Journey {
        let predicate = #Predicate<JourneyLocalDataSource> { dataSource in
            return dataSource.isEqual(to: journey)
        }
        
        do {
            try self.context.delete(model: JourneyLocalDataSource.self, where: consume predicate)
        } catch {
            throw error
        }
    }
}

// MARK: - Privates

private extension AppJourneyRepository {
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

    func journeysFromContext(count: Int? = nil, matching predicate: @escaping (JourneyLocalDataSource) -> Bool) throws -> [JourneyLocalDataSource] {
        let predicate = #Predicate<JourneyLocalDataSource> { journey in
            return consume predicate(journey)
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)

        if let count {
            let result = try self.context.fetch(consume descriptor, batchSize: count)
            return result.map { $0 }
        } else {
            let result = try self.context.fetch(consume descriptor)
            return result
        }
    }
}
