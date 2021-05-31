//
//  MapController.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-27.
//

import UIKit
import MapKit
import CoreMotion
import CoreLocation

class MapController: UIViewController, AlertDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var annotationButton: UIButton!
    var followUser: Bool = false {
        didSet {
            print("followUser: ", followUser)
            if followUser {
                locationButton.setImage(UIImage(systemName: "location.fill.viewfinder"), for: .normal)
            }
            else {
                locationButton.setImage(UIImage(systemName: "location.viewfinder"), for: .normal)
            }
        }
    }
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private let regionInMeters: Double = 250
    
    let annotationId = "annotationIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        addMapDragRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func showAlert() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "alert") as! AlertController
        myAlert.delegate = self
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func addMapDragRecognizer() {
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragMap(gestureRecognizer:)))
            mapDragRecognizer.delegate = self
            self.mapView.addGestureRecognizer(mapDragRecognizer)
    }
    
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == .began) {
            if followUser == true {
                followUser = false
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func addMapAnnotation(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func centerUserLocation(_ sender: UIButton) {
        followUser.toggle()
    }
}

extension MapController: MKMapViewDelegate, CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        configureLocationServices()
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.register(SnapshotAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.delegate = self
        mapView.showsBuildings = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        centerViewOnUserLocation()
    }
    
    func addAnnotation(status: String, description: String) {
        print("currentCoord: ", currentCoordinate)
        let annotation = MKPointAnnotation()
        annotation.title = status
        annotation.subtitle = description
        if let position = currentCoordinate {
            annotation.coordinate = position
            mapView.addAnnotation(annotation)
        }
    }
    
    func centerViewOnUserLocation() {
        guard let currentLocation = locationManager.location else { return }
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func configureLocationServices() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined || status == .denied || status == .restricted {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        configureLocationServices()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else { return }
        
        if followUser {
            centerViewOnUserLocation()
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }

        let annotationIdentifier = MKMapViewDefaultAnnotationViewReuseIdentifier

        var annotationView: SnapshotAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? SnapshotAnnotationView {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av as? SnapshotAnnotationView
        }

        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true

            if let annotationImage = annotation.title??.textToImage(fontSize: 24) {
                annotationView.image = annotationImage
            }
            else {
                annotationView.image = UIImage(systemName: "mappin.and.ellipse")
            }
        }

        return annotationView
    }
}

class SnapshotAnnotationView: MKAnnotationView {
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

private extension SnapshotAnnotationView {
    func configure() {
        canShowCallout = true
        configureDetailView()
    }

    func configureDetailView() {
        guard let annotation = annotation else { return }

        let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))

        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false

        let options = MKMapSnapshotter.Options()
        options.size = rect.size
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 250, pitch: 65, heading: 0)

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

        detailCalloutAccessoryView = snapshotView
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: rect.width),
            snapshotView.heightAnchor.constraint(equalToConstant: rect.height)
        ])
    }
}
