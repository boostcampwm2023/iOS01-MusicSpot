//
//  JourneyError.swift
//  MSError
//
//  Created by 이창준 on 6/16/24.
//

public enum JourneyError: Error {
    case noTravelingJourney
    case multipleTravelingJourneys
    case noLocalUpdate
    case repositoryError(Error)
}