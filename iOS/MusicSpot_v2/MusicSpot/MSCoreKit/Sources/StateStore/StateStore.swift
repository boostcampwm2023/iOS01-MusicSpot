//
//  StateStore.swift
//  StateStore
//
//  Created by 이창준 on 4/17/24.
//

import Foundation

@MainActor
public protocol StateStore<Action> {
    associatedtype Action
    
    func process(_ action: Action) async
}
