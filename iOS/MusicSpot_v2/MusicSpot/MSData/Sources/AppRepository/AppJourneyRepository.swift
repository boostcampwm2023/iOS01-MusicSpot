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
import Repository

public final class AppJourneyRepository: JourneyRepository {
    private var context: ModelContext!

    public func fetchJourneys(in region: Region) async throws -> [Journey] {
        []
    }
}
