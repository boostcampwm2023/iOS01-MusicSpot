//
//  MSImageFetcher+UIImageView.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

import MSCacheStorage
import MSImageFetcher

extension UIImageView: MSImageFetcherCompatible { }

extension MSImageFetcherWrapper where Base: UIImageView {
    
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
    
    // MARK: - Helpers
    
    private func fetchImage(with imageURL: URL,
                            forKey key: String) async -> Data? {
        let imageData = await MSImageFetcher.shared.fetchImage(from: imageURL, forKey: key)
        return imageData
    }
    
    @MainActor
    private func updateImage(_ imageData: Data) {
        self.base.image = UIImage(data: imageData)
    }
    
}
