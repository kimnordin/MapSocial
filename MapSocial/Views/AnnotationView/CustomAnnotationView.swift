//
//  CustomAnnotationView.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-06-01.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? { didSet { configureDetailView() } }
    var sateliteImage: Bool = false

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
}

private extension CustomAnnotationView {
    func configure() {
        canShowCallout = true
        configureDetailView()
    }

    func configureDetailView() {
        guard let annotation = annotation else { return }

        let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))
        
        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.alignment = .fill
        contentView.spacing = 10
        
        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.layer.cornerRadius = 5
        snapshotView.layer.masksToBounds = true

        let options = MKMapSnapshotter.Options()
        options.size = rect.size
        options.mapType = .satelliteFlyover
        
        options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 250, pitch: 0, heading: 0)

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            let imageView = UIImageView(frame: rect)
            imageView.image = snapshot.image
            snapshotView.addSubview(imageView)
        }
        
        let subLabel = UILabel()
        if let sub = annotation.subtitle {
            subLabel.text = sub
        }
        
        if sateliteImage {
        }
        
        
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateTimeString = formatter.string(from: nowDate)
        
        let timeLabel = UILabel()
        timeLabel.font = timeLabel.font.withSize(10)
        timeLabel.text = dateTimeString
        
        contentView.addArrangedSubview(subLabel)
        contentView.addArrangedSubview(timeLabel)
//        contentView.addArrangedSubview(snapshotView)

        detailCalloutAccessoryView = contentView
//        NSLayoutConstraint.activate([
//            snapshotView.widthAnchor.constraint(equalToConstant: rect.width),
//            snapshotView.heightAnchor.constraint(equalToConstant: rect.height)
//        ])
    }
}
