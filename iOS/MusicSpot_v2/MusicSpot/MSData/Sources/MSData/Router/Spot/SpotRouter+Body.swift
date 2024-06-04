//
//  SpotRouter+Body.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation
import MSNetworking

extension SpotRouter {
    public var body: HTTPBody? {
        switch self {
        case let .upload(dto, id):
            let multipartData =
            [MultipartData(type: .image, name: "image", content: dto.photoData),
             MultipartData(name: "journeyId", content: dto.journeyID ),
             MultipartData(name: "timestamp", content: dto.timestamp),
             MultipartData(name: "coordinate", content: dto.coordinate)]
            return HTTPBody(type: .multipart,
                            boundary: "Boundary-\(id.uuidString)",
                            multipartData: multipartData)
        default:
            return nil
        }
    }
}
