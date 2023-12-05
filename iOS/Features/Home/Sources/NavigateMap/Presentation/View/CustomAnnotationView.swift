//
//  CustomAnnotationView.swift
//  Home
//
//  Created by 윤동주 on 11/23/23.
//

import UIKit
import CoreLocation
import MapKit
import MSDesignSystem

class CustomAnnotation: NSObject, MKAnnotation {

    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var photoData: Data
    
    init(title: String, coordinate: CLLocationCoordinate2D, photoData: Data) {
        self.title = title
        self.coordinate = coordinate
        self.photoData = photoData
        
    }
    
}

import MapKit
import UIKit

final class CustomAnnotationView: MKAnnotationView {

    // MARK: - Layout Constants

    enum Constants {
        static let markerWidth: CGFloat = 43
        static let markerHeight: CGFloat = 53
        static let thumbnailImageViewSize: CGFloat = markerWidth - inset * 2
        static let inset: CGFloat = 4
    }

    // MARK: - UI Components

    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Object Lifecycle

    override var annotation: MKAnnotation? {
        didSet {
            clusteringIdentifier = "spotIdentifier"
        }
    }
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setConstraints()
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConstraints()
        render()
    }

    // MARK: - View Lifecycle
    override func prepareForDisplay() {
        super.prepareForDisplay()
        setThumbnailImage()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = markerImageView.bounds.size
    }

    // MARK: - Methods

    func setThumbnailImage() {
        guard let annotation = annotation as? CustomAnnotation
        else { return }
        self.thumbnailImageView.image = UIImage(data: annotation.photoData)
    }

    private func render() {
        thumbnailImageView.layer.cornerRadius = Constants.thumbnailImageViewSize / 2
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderWidth = 1
        thumbnailImageView.layer.borderColor = .none
    }

    private func setConstraints() {
        
        self.addSubview(markerImageView)
        self.addSubview(thumbnailImageView)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            markerImageView.widthAnchor.constraint(equalToConstant: Constants.markerWidth),
            markerImageView.heightAnchor.constraint(equalToConstant: Constants.markerHeight),
            
            thumbnailImageView.topAnchor.constraint(equalTo: markerImageView.topAnchor, constant: Constants.inset),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.thumbnailImageViewSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.thumbnailImageViewSize),
            thumbnailImageView.centerXAnchor.constraint(equalTo: markerImageView.centerXAnchor)
        ])

    }
}

class ClusterAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            displayPriority = .defaultHigh
        }
    }
    
    enum Constants {
        static let markerWidth: CGFloat = 43
        static let markerHeight: CGFloat = 53
        static let thumbnailImageViewSize: CGFloat = markerWidth - inset * 2
        static let inset: CGFloat = 4
    }

    // MARK: - UI Components

    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .msColor(.primaryTypo)
        return imageView
    }()

    // MARK: - Object Lifecycle

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setConstraints()
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConstraints()
        render()
    }

    // MARK: - View Lifecycle
    override func prepareForDisplay() {
        super.prepareForDisplay()
        setThumbnailImage()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = markerImageView.bounds.size
    }

    // MARK: - Methods

    func setThumbnailImage() {
        guard let annotation = self.annotation as? MKClusterAnnotation else {return}
        self.thumbnailImageView.image = UIImage(systemName: "\(annotation.memberAnnotations.count).circle.fill")
    }

    private func render() {
        thumbnailImageView.layer.cornerRadius = Constants.thumbnailImageViewSize / 2
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderWidth = 1
        thumbnailImageView.layer.borderColor = .none
    }

    private func setConstraints() {
        
        self.addSubview(markerImageView)
        self.addSubview(thumbnailImageView)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            markerImageView.widthAnchor.constraint(equalToConstant: Constants.markerWidth),
            markerImageView.heightAnchor.constraint(equalToConstant: Constants.markerHeight),
            
            thumbnailImageView.topAnchor.constraint(equalTo: markerImageView.topAnchor, constant: Constants.inset),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.thumbnailImageViewSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.thumbnailImageViewSize),
            thumbnailImageView.centerXAnchor.constraint(equalTo: markerImageView.centerXAnchor)
        ])

    }
}
