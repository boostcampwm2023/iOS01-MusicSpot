//
//  MusicUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation
import MusicKit

import Entity

public enum MusicFetchMethod {
    case term(String)
    case rank
}

public protocol MusicUseCase {
    /// 주어진 방식에 따라 음악을 검색합니다.
    ///
    /// `MusicFetchMethod`에는 두가지 방식이 있습니다.
    /// 1. term(String) \
    /// 주어진 **term**에 따라 음악을 검색합니다.
    /// 2. rank \
    /// 현재 국가의 **Top100** 음악을 검색합니다.
    /// - Parameters:
    ///   - method: 음악을 불러오는 방식
    func searchMusics(by method: MusicFetchMethod?) -> MusicItemCollection<Song>

    /// 주어진 URL로부터 앨범 커버 이미지를 불러옵니다.
    /// - Parameters:
    ///   - url: 앨범 커버 이미지 URL
    /// - Returns: 앨범 커버 이미지 데이터
    func fetchAlbumCover(from url: String) async throws -> Data
}

extension MusicUseCase {
    public func searchMusics(by method: MusicFetchMethod? = nil) -> MusicItemCollection<Song> {
        searchMusics(by: method)
    }
}
