//
//  SpotSaveViewModel.swift
//  Spot
//
//  Created by 전민건 on 11/29/23.
//

import Foundation
import Combine

import MSData
import MSLogger

public final class SpotSaveViewModel {
    
    // MARK: - Properties
    
    private var repository: SpotRepository
//    private let msNetworking = MSNetworking(session: URLSession.shared)
    private var subscriber: Set<AnyCancellable> = []
    internal var journeyID: UUID?
    internal var coordinate: [Double]?
    
    // MARK: - Initializer
    
    public init(repository: SpotRepository) {
        self.repository = repository
    }
    
}

// MARK: - Interface

internal extension SpotSaveViewModel {
    
//    func upload(data: Data, using router: Router?) {
//        guard let router, let journeyID, let coordinate else {
//            MSLogger.make(category: .spot).debug("journeyID와 coordinate ID가 view model에 전달되지 않았습니다.")
//            return
//        }
//        let timestamp = Data().base64EncodedString()
//        print(timestamp)
//        
//        self.msNetworking.request(SpotDTO.self, router: router)
//            .sink { response in
//                switch response {
//                case .failure(let error):
//                    MSLogger.make(category: .network).debug("\(error): 정상적으로 Spot을 서버에 보내지 못하였습니다.")
//                default:
//                    return
//                }
//            } receiveValue: { spot in
//                // 받은 데이터 처리
//            }
//            .store(in: &subscriber)
//    }
    
}
