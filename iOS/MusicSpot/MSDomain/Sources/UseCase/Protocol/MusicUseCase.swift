//
//  MusicUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation
import MusicKit

import Entity

// MARK: - MusicFetchMethod

public enum MusicFetchMethod {
    case term(String)
    case rank(Genre)
}

// MARK: - MusicUseCase

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
    func searchMusics(by method: MusicFetchMethod) async throws -> MusicItemCollection<Song>

    /// 주어진 앨범의 앨범 커버 이미지를 불러옵니다.
    /// - Parameters:
    ///   - album: 커버 이미지를 불러올 앨범에 대한 정보
    /// - Returns: 앨범 커버 이미지 데이터
    func fetchAlbumCover(of album: Album) async throws -> Data

    /// 주어진 URL로부터 앨범 커버 이미지를 불러옵니다.
    /// - Parameters:
    ///   - url: 앨범 커버 이미지 URL
    /// - Returns: 앨범 커버 이미지 데이터
    func fetchAlbumCover(from url: URL) async throws -> Data

    /// 주어진 URL로부터 앨범 커버 이미지를 불러옵니다.
    /// - Parameters:
    ///   - url: 앨범 커버 이미지 URL 형태의 String
    /// - Returns: 앨범 커버 이미지 데이터
    func fetchAlbumCover(from url: String) async throws -> Data
}
