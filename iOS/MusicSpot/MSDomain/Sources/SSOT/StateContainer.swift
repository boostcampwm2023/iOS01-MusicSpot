//
//  StateContainer.swift
//  SSOT
//
//  Created by 이창준 on 6/13/24.
//

public struct StateContainer {
    // MARK: - Properties

    public private(set) var appState: AppState
    public private(set) var userState: UserState

    // MARK: - Shared

    public static let `default` = StateContainer()

    // MARK: - Initializer

    public init(appState: AppState = .shared, userState: UserState = .shared) {
        self.appState = appState
        self.userState = userState
    }
}
