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
        
        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.alignment = .fill
        contentView.spacing = 10
        
        // User input Description
        let textLabel = UILabel()
        if let sub = annotation.subtitle {
            textLabel.text = sub
        }
        
        // Date created & formatted
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateTimeString = formatter.string(from: nowDate)
        
        // Displayed creation Date
        let timeLabel = UILabel()
        timeLabel.font = timeLabel.font.withSize(10)
        timeLabel.text = dateTimeString
        
        contentView.addArrangedSubview(textLabel)
        contentView.addArrangedSubview(timeLabel)
        
        detailCalloutAccessoryView = contentView
    }
}
