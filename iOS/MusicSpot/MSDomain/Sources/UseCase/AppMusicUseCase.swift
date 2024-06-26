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

    public func searchMusics(by method: MusicFetchMethod) -> MusicItemCollection<Song> {
        switch method {
        case .term(let term):
            return self.musicRepository.searchMusic(term: term)
        case .rank(let genre):
            return self.musicRepository.fetchTopRanking(genre)
        }
    }

    public func fetchAlbumCover(of album: Album) async throws(MusicError) -> Data {
        do {
            return try await self.musicRepository.fetchAlbumCover(of: album)
        } catch {
            throw .repositoryFailure(error)
        }
    }

    public func fetchAlbumCover(from url: URL) async throws(MusicError) -> Data {
        do {
            return try await self.musicRepository.fetchAlbumCover(url)
        } catch {
            throw .repositoryFailure(error)
        }
    }

    public func fetchAlbumCover(from url: String) async throws(MusicError) -> Data {
        guard let url = URL(string: url) else {
            throw .invalidURL
        }

        do {
            return try await self.musicRepository.fetchAlbumCover(url)
        } catch {
            throw .repositoryFailure(error)
        }
    }
}
