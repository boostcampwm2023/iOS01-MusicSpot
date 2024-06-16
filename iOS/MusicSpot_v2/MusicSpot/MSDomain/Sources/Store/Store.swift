//
//  Store.swift
//  Store
//
//  Created by 이창준 on 6/13/24.
//

import Observation

@Observable
public final class Store {
    public var state: AppState

    init(state: AppState) {
        self.state = state
    }
}
