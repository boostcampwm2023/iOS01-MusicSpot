//
//  FakeCodableData.swift
//  MSFoundation
//
//  Created by 이창준 on 11/15/23.
//

import Foundation

struct FakeCodableData: Codable, Equatable {
    let id: UUID
    var name: String
    var number: Int

    init(id: UUID = UUID(), name: String, number: Int) {
        self.id = id
        self.name = name
        self.number = number
    }

    func isEqual(to data: FakeCodableData) -> Bool {
        name == data.name && number == data.number
    }
}
