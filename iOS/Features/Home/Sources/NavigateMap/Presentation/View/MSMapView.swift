//
//  MSMapView.swift
//
//
//  Created by 윤동주 on 12/5/23.
//

import UIKit
import MapKit

class MSMapView: MKMapView {
    
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: CGRect.zero)
        // 유저의 위치를 추적하여 보여줌.
        self.setUserTrackingMode(.followWithHeading, animated: true)
        
        /// 재사용 가능하도록 CustomAnnotation 등록
        self.register(CustomAnnotationView.self,
                      forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        self.register(ClusterAnnotationView.self,
                      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    // 식별자를 갖고 Annotation view 생성
    func setupAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        // dequeueReusableAnnotationView: 식별자를 확인하여 사용가능한 뷰가 있으면 해당 뷰를 반환
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotationView.self), for: annotation)
    }
    
    func addAnnotation(title: String, coordinate: CLLocationCoordinate2D, photoData: Data) {
        let annotation = CustomAnnotation(title: title,
                                          coordinate: coordinate,
                                          photoData: photoData)
        // mapView에 Annotation 추가
        self.addAnnotation(annotation)
    }
    
    func createPolyLine(coordinates: [Coordinate]) {
        let locations = coordinates.map { coordinate in
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
        addPolyLineToMap(locations: locations)
        
    }
    
    func addPolyLineToMap(locations: [CLLocation?]) {
        let coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        dump(coordinates)
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        print(polyline)
        self.addOverlay(polyline)
        
    }
    
}

extension MSMapView: MKMapViewDelegate {
        /// 현재까지의 polyline들을 지도 위에 그림
        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyLine = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
    
            let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .orange
            renderer.lineWidth = 5.0
    
            return renderer
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        if annotation is MKClusterAnnotation {
            return ClusterAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        }
        var annotationView: MKAnnotationView?
        
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotationView.self),
                                                               for: annotation)
        return annotationView
    }
    
}