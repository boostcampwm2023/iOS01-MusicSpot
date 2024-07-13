//
//  AppState+Environment.swift
//  Store+SwiftUI
//
//  Created by 이창준 on 6/18/24.
//

import SwiftUI

import SSOT

/// `@Environment`와 함께 사용할 수 있도록 `EnvironmentValues`를 확장해주었습니다.
/// 다만, 이미 `default` static 프로퍼티를 사용함으로써 단일성이 확보된 모델에 대해 `@Environment`를 사용할 이유가 있는가는
/// 의문점으로 남아있습니다.
///
/// 별도의 `AppState` (modified)가 필요한 경우 유용할 수 있을까 싶었는데,
/// 해당 동작도 `AppState` 구조체의 생성자를 `public`으로 풀어주며 단순히 새로운 인스턴스를 생성하는 것으로 구현됩니다.
///
/// 일단 남겨두고, 무의미하다는 생각이 지속되면 삭제하도록 하겠습니다.

extension EnvironmentValues {
    @Entry public var states = StateContainer.default
}

extension View {
    public func inject(_ states: StateContainer) -> some View {
        environment(\.states, states)
    }

    public func inject(
        appState: AppState = .shared,
        userState: UserState = .shared)
        -> some View
    {
        let container = StateContainer(appState: appState, userState: userState)
        return environment(\.states, container)
    }
}
