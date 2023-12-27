//
//  SongRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation
import MusicKit

public protocol SongRepository {
    
    func fetchSong(withID id: String) async -> Result<Song, Error>
    func fetchSongList(with term: String) async -> Result<MusicItemCollection<Song>, Error>
    @available(iOS 16.0, *)
    func fetchSongListByRank() async -> Result<MusicItemCollection<Song>, Error>
    
}
