//
//  Router.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/15/24.
//

import SwiftUI

/// SwiftUI에서 Navigation 로직을 담당하는 클래스입니다.
@MainActor
@Observable
public final class Router {
    
    /// 목적지 목록을 보관하는 `NavigationPath`
    public var navigationPath = NavigationPath()
    
    /// 목적 View로 이동합니다. `Destination` enum 타입에 목적지를 추가한 뒤 사용할 수 있습니다.
    public func navigate(to destination: Destination) {
        self.navigationPath.append(destination)
    }
    
    /// 상위 View로 돌아갑니다.
    public func pop() {
        self.navigationPath.removeLast()
    }
    
    /// 최상위 View로 이동합니다.
    public func popToRoot() {
        let numberOfChilds = self.navigationPath.count
        self.navigationPath.removeLast(numberOfChilds)
    }
    
}
