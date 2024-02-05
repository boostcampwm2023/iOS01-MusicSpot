//
//  JourneyPathRenderer.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.02.01.
//

import Foundation
import MapKit

public final class JourneyPathRenderer: MKOverlayRenderer {
    
    // MARK: - Constants
    
    private enum Metric {
        /// 선을 그리기 위한 지도 상 최소 Point 개수
        static let minimumPoints = 5.0
    }
    
    // MARK: - Properties
    
    private let journeyPath: JourneyPath
    
    // MARK: - Initializer
    
    public init(journeyPath: JourneyPath) {
        self.journeyPath = journeyPath
        super.init(overlay: journeyPath)
    }
    
    // MARK: - Functions
    
    public override func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        return self.journeyPath.pathBounds.intersects(mapRect)
    }
    
    public override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let lineWidth = MKRoadWidthAtZoomScale(zoomScale)
        let clipRect = mapRect.insetBy(dx: -lineWidth, dy: -lineWidth)
        
        let points = self.journeyPath.pathLocations.map { MKMapPoint($0.coordinate) }
        if let path = self.pathForPoints(points, mapRect: clipRect, zoomScale: zoomScale) {
            context.addPath(path)
            context.setStrokeColor(.msColor(.musicSpot))
            context.setLineJoin(.round)
            context.setLineCap(.round)
            context.setLineWidth(lineWidth)
            context.strokePath()
        }
    }
    
    /// 주어진 Map Point들로부터 `CGPath`를 생성합니다.
    private func pathForPoints(_ points: [MKMapPoint], mapRect: MKMapRect, zoomScale: MKZoomScale) -> CGPath? {
        guard points.count > 1 else { return nil }
        
        let path = CGMutablePath()
        
        // 선을 그리기 위한 최소 거리를 설정하고, 해당 거리보다 적다면 선을 그리지 않고 넘어갑니다. (최적화를 위한 과정)
        // 피타고라스 정리를 이용해 두 점 사이의 거리를 비교합니다.
        let minimumPointDelta = Metric.minimumPoints / zoomScale
        let cSquared = pow(minimumPointDelta, 2)
        
        guard var lastPoint = points.first else { return nil }
        for (index, point) in points.enumerated() {
            if index == .zero { continue }
            
            let aSquared = pow(point.x - lastPoint.x, 2)
            let bSquared = pow(point.y - lastPoint.y, 2)
            if aSquared + bSquared >= cSquared {
                let drawingPoint = self.point(for: point)
                path.addLine(to: drawingPoint)
            }
            lastPoint = point
        }
        
        return path
    }
    
}
