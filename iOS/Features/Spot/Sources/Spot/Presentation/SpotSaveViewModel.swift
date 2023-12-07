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
    
    public enum Action {
        case startUploadSpot
    }
    
    // MARK: - Properties
    
    private var repository: SpotRepository
    private var subscriber: Set<AnyCancellable> = []
    private let journeyID: UUID
    private let coordinate: CoordinateDTO
    
    // MARK: - Initializer
    
    public init(repository: SpotRepository,
                journeyID: UUID,
                coordinate: CoordinateDTO) {
        self.repository = repository
        self.journeyID = journeyID
        self.coordinate = coordinate
    }
    
}

// MARK: - Interface: Actions

internal extension SpotSaveViewModel {
    
    func trigger(_ action: Action, using data: Data) {
        switch action {
        case .startUploadSpot:
            Task {
                let spot = CreateSpotRequestDTO(journeyID: self.journeyID,
                                                coordinate: self.coordinate,
                                                timestamp: Date(),
                                                photoData: data)
                let result = await self.repository.upload(spot: spot)
                switch result {
                case .success:
                    MSLogger.make(category: .network).debug("성공적으로 업로드되었습니다.")
                case .failure:
                    MSLogger.make(category: .network).debug("업로드에 실패하였습니다.")
                }
            }
        }
    }
    
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
