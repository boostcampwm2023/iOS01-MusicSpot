//
//  CustomAnnotation.swift
//  Home
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var photoData: Data
    
    // MARK: - Initializer
    
    init(title: String,
         coordinate: CLLocationCoordinate2D,
         photoData: Data) {
        self.title = title
        self.coordinate = coordinate
        self.photoData = photoData
    }
    
}
