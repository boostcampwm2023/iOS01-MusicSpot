//
//  MSImageFetcher+UIImageView.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

import MSCacheStorage
import MSImageFetcher

// MARK: - UIImageView + MSImageFetcherCompatible

extension UIImageView: @retroactive MSImageFetcherCompatible { }

extension MSImageFetcherWrapper where Base: UIImageView {

    // MARK: Public

    /// URL로부터 이미지를 가져와 설정합니다.
    /// - Parameters:
    ///   - imageURL: `UIImageView`에 설정할 이미지의 URL
    ///   - key: 이미지를 불러오는 Task를 구분하기 위한 Key
    public func setImage(with imageURL: URL, forKey key: String) {
        Task {
            guard let imageData = await self.fetchImage(with: imageURL, forKey: key) else {
                return
            }

            await self.updateImage(imageData)
        }
    }

    // MARK: Private

    // MARK: - Helpers

    private func fetchImage(
        with imageURL: URL,
        forKey key: String)
        async -> Data?
    {
        await MSImageFetcher.shared.fetchImage(from: imageURL, forKey: key)
    }

    @MainActor
    private func updateImage(_ imageData: Data) {
        base.image = UIImage(data: imageData)
    }
}
