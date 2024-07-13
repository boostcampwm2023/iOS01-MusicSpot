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
    // MARK: - Properties

    private let musicRepository: MusicRepository

    // MARK: - Initializer

    init(musicRepository: MusicRepository) {
        self.musicRepository = musicRepository
    }

    // MARK: - Functions

    public func searchMusics(by method: MusicFetchMethod) async throws(MusicError) -> MusicItemCollection<Song> {
        do {
            switch method {
            case .term(let term):
                return try await self.musicRepository.searchMusic(term: term)
            case .rank(let genre):
                return try await self.musicRepository.fetchTopRanking(genre)
            }
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchAlbumCover(of album: Album) async throws(MusicError) -> Data {
        do {
            return try await self.musicRepository.fetchAlbumCover(of: album)
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchAlbumCover(from url: URL) async throws(MusicError) -> Data {
        do {
            return try await self.musicRepository.fetchAlbumCover(url)
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchAlbumCover(from url: String) async throws(MusicError) -> Data {
        guard let url = URL(string: url) else {
            throw .invalidURL
        }

        do {
            return try await self.musicRepository.fetchAlbumCover(url)
        } catch {
            throw .repositoryError(error)
        }
    }
}
