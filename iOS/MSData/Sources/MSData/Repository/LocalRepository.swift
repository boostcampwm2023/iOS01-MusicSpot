//
//  LocalRepository.swift
//  MSData
//
//  Created by 전민건 on 12/10/23.
//

import Foundation

import MSDomain
import MSPersistentStorage

public protocol LocalRepository {

    var key: String { get }
    func save(coordinateDTO: CoordinateDTO)
    func loadCoordinates() -> [Coordinate]?

}

public struct LocalRepositoryImplementation: LocalRepository {
    
    // MARK: - Properties
    
    private var storage = FileManagerStorage()
    private var coordinateURL: URL?
    public let key: String
    
    // MARK: - Initializer
    
    public init() {
        self.key = UUID().uuidString
    }
    
    // MARK: - Functions
    
    public func save(coordinateDTO: CoordinateDTO) {
        self.storage.set(value: coordinateDTO, forKey: self.key)
    }
    
    public func loadCoordinates() -> [Coordinate]? {
        let coordinates = self.storage.getAllOf(CoordinateDTO.self)
        return coordinates?.compactMap { $0.toDomain() }
    }
    
    public func deleteAll() {
        try? self.storage.deleteAll()
    }
    
}
