//
//  UserDefaultsWrapped.swift
//  MSFoundation
//
//  Created by 이창준 on 11/15/23.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapped<T: Codable> {

    // MARK: Lifecycle

    public init(
        _ key: String,
        defaultValue: T,
        userDefaults: UserDefaults = .standard)
    {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    // MARK: Public

    public var wrappedValue: T {
        get { load(forKey: key) ?? defaultValue }
        set { save(newValue) }
    }

    // MARK: Private

    private let key: String
    private var defaultValue: T
    private let userDefaults: UserDefaults
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private func save(_ newValue: T) {
        if let encoded = try? encoder.encode(newValue) {
            userDefaults.setValue(encoded, forKey: key)
        }
    }

    private func load(forKey key: String) -> T? {
        guard
            let savedData = userDefaults.object(forKey: key) as? Data,
            let loadedObject = try? decoder.decode(T.self, from: savedData)
        else {
            return nil
        }
        return loadedObject
    }
}
