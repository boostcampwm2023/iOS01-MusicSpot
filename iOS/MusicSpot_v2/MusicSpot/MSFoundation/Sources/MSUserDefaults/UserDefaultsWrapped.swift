//
//  UserDefaultsWrapped.swift
//  MSFoundation
//
//  Created by 이창준 on 11/15/23.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapped<T: Codable> {
    private let key: String
    private var defaultValue: T
    private let userDefaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    public init(_ key: String,
                defaultValue: T,
                userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T {
        get { self.load(forKey: self.key) ?? self.defaultValue }
        set { self.save(newValue) }
    }

    private func save(_ newValue: T) {
        if let encoded = try? self.encoder.encode(newValue) {
            self.userDefaults.setValue(encoded, forKey: self.key)
        }
    }

    private func load(forKey key: String) -> T? {
        guard let savedData = self.userDefaults.object(forKey: key) as? Data,
              let loadedObject = try? self.decoder.decode(T.self, from: savedData) else {
            return nil
        }
        return loadedObject
    }
}
