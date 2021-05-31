//
//  MapView.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-27.
//

import UIKit
import MapKit
import CoreMotion
import CoreLocation

@IBDesignable
class MapView: UIView {

    @IBOutlet weak var mapView: MKMapView!
    private let viewSelfId = "MapView"
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    private var startLocation: CLLocation!
    private var lastLocation: CLLocation!
    private let regionRadius: CLLocationDistance = 1000
    private let regionInMeters: Double = 250
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let contentView = loadViewFromNib(id: viewSelfId)
        addSubview(contentView!)
        setupLocationManager()
        setupMapView()
    }
}

extension MapView: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.showsBuildings = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        centerViewOnUserLocation()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
}
