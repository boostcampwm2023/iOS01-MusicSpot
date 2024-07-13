//
//  Music+MusicKit.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation
import MusicKit

extension Music {
    public init(_ song: Song) {
        self.init(
            id: song.id.rawValue,
            title: song.title,
            artist: song.artistName,
            albumCover: AlbumCover(song.artwork))
    }
}

extension AlbumCover {
    public init?(
        _ artwork: Artwork?,
        width: UInt32 = 500,
        height: UInt32 = 500)
    {
        guard let artwork else { return nil }
        self.init(
            width: width,
            height: height,
            url: artwork.url(width: Int(width), height: Int(height)),
            backgroundColor: artwork.backgroundColor?.hexValue)
    }
}

import CoreGraphics

extension CGColor {
    fileprivate var hexValue: String? {
        guard let components else {
            return nil
        }

        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)

        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}
