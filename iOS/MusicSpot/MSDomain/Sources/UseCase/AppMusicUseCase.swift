//
//  AppMusicUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation
import MusicKit

import MSError
import Repository

public final class AppMusicUseCase: MusicUseCase {

    // MARK: Lifecycle

    // MARK: - Initializer

    init(musicRepository: MusicRepository) {
        self.musicRepository = musicRepository
    }

    // MARK: Public

    // MARK: - Functions

    public func searchMusics(by method: MusicFetchMethod) async throws(MusicError)
        -> MusicItemCollection<Song>
    { // swiftlint:disable:this all
        do {
            switch method {
            case .term(let term):
                return try await musicRepository.searchMusic(term: term)
            case .rank(let genre):
                return try await musicRepository.fetchTopRanking(genre)
            }
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchAlbumCover(of album: Album) async throws(MusicError) -> Data { // swiftlint:disable:this all
        do {
            return try await musicRepository.fetchAlbumCover(of: album)
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchAlbumCover(from url: URL) async throws(MusicError) -> Data { // swiftlint:disable:this all
        do {
            return try await musicRepository.fetchAlbumCover(url)
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchAlbumCover(from url: String) async throws(MusicError) -> Data { // swiftlint:disable:this all
        guard let url = URL(string: url) else {
            throw .invalidURL
        }

        do {
            return try await musicRepository.fetchAlbumCover(url)
        } catch {
            throw .repositoryError(error)
        }
    }

    // MARK: Private

    // MARK: - Properties

    private let musicRepository: MusicRepository
}
