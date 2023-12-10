//
//  MapViewModel.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

public protocol MapViewModel: AnyObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get set }
    
    func trigger(_ action: Action)
}
