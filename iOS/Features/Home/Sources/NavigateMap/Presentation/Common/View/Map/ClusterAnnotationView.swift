//
//  ClusterAnnotationView.swift
//  Home
//
//  Created by 이창준 on 2023.12.06.
//

import MapKit

import MSDesignSystem

final class ClusterAnnotationView: MKAnnotationView {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let markerWidth: CGFloat = 60.0
        static let markerHeight: CGFloat = 60.0
        static let inset: CGFloat = 4
        static let thumbnailImageViewSize: CGFloat = Metric.markerWidth - Metric.inset * 2
        
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
    
    // MARK: - Properties
    
    override var annotation: MKAnnotation? {
        didSet { self.displayPriority = .defaultHigh }
    }
    
    // MARK: - Object Lifecycle
    
    override init(annotation: MKAnnotation?,
                  reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.configureLayout()
        self.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - View Lifecycle
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.updateThumbnailImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bounds.size = self.markerImageView.bounds.size
    }
    
    // MARK: - UI Configuration
    
    private func updateThumbnailImage() {
        guard let annotation = self.annotation as? MKClusterAnnotation else {return}
        self.thumbnailImageView.image = UIImage(systemName: "\(annotation.memberAnnotations.count).circle.fill")
    }
    
    private func render() {
        self.thumbnailImageView.layer.cornerRadius = Metric.thumbnailImageViewSize / 2
        self.thumbnailImageView.clipsToBounds = true
        self.thumbnailImageView.layer.borderWidth = 1
        self.thumbnailImageView.layer.borderColor = .none
    }
    
    private func configureLayout() {
        [
            self.markerImageView,
            self.thumbnailImageView
        ].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            self.markerImageView.widthAnchor.constraint(equalToConstant: Metric.markerWidth),
            self.markerImageView.heightAnchor.constraint(equalToConstant: Metric.markerHeight),
            
            self.thumbnailImageView.topAnchor.constraint(equalTo: self.markerImageView.topAnchor,
                                                         constant: Metric.inset),
            self.thumbnailImageView.widthAnchor.constraint(equalToConstant: Metric.thumbnailImageViewSize),
            self.thumbnailImageView.heightAnchor.constraint(equalToConstant: Metric.thumbnailImageViewSize),
            self.thumbnailImageView.centerXAnchor.constraint(equalTo: self.markerImageView.centerXAnchor)
        ])
    }
    
}
