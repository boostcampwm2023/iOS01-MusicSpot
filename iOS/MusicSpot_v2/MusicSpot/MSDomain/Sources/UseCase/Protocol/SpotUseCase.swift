//
//  SpotUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation

import Entity

public protocol SpotUseCase {
    /// Spot의 이미지들을 불러옵니다.
    /// - Parameters:
    ///   - spot: 이미지를 불러올 Spot
    /// - Returns: Spot에 기록된 이미지 데이터와 Spot 자체에 대한 데이터 묶음
    func fetchPhotos(of spot: Spot) async throws -> AsyncStream<(Spot, Data)>

    /// 새로운 Spot을 추가합니다.
    /// - Parameters:
    ///   - spot: 추가할 새로운 Spot
    /// - Returns: 추가된 Spot 정보를 담은 인스턴스
    @discardableResult
    func recordNewSpot(_ spot: Spot) async throws -> Spot
}
