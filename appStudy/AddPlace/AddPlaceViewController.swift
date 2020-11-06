//
//  AddPlaceViewController.swift
//  appStudy
//
//  Created by Clement  Wekesa on 04/11/2020.
//

import CoreLocation
import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, name: String)
    func showAlert(place: MKMapItem)
}

@available(iOS 10.0, *)
class AddPlaceViewController: UIViewController, CLLocationManagerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let manager = CLLocationManager()
    var resultSearchController: UISearchController? = nil

    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add gesture information
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        map.addGestureRecognizer(gestureRecognizer)

        setupSearchTable()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            dropPinZoomIn(placemark: MKPlacemark(coordinate: location.coordinate))

        }
    }

    func render(_ location: CLLocation) {
        let coordinate = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        map.setRegion(region,
                      animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        map.addAnnotation(pin)
    }
    
    // This looks up the tapped location and adds description
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()

        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }
    
    // Setup the search table
    func setupSearchTable() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true

        locationSearchTable.mapView = map

        locationSearchTable.handleMapSearchDelegate = self
    }
}

@available(iOS 10.0, *)
extension AddPlaceViewController: UIGestureRecognizerDelegate {

    @objc
    func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let cgLocation = gestureReconizer.location(in: map)
        let coordinate = map.convert(cgLocation, toCoordinateFrom: map)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        lookUpCurrentLocation(location: location) { (placemark) in
            if let placemark = placemark {
                self.showAlert(place: MKMapItem(placemark: MKPlacemark(placemark: placemark)))
            }
        }

    }
}

@available(iOS 10.0, *)
extension AddPlaceViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, name: String = "") {
        let newName = name == "" ? placemark.name : name
        // clear existing pins
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = newName
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }

        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    func showAlert(place: MKMapItem) {
        let alertController = UIAlertController(title: "Do you want to save this location?",
                                                message: "If you save this location you will be able to get the weather for this place",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismis", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.dropPinZoomIn(placemark: place.placemark)
            // Save to coreData
            let newPlace = Places(context: self.context)
            newPlace.name = place.placemark.name
            newPlace.lon = place.placemark.location?.coordinate.longitude ?? 0.0
            newPlace.lat = place.placemark.location?.coordinate.latitude ?? 0.0
            try! self.context.save()
        }))

        self.present(alertController, animated: true, completion: nil)
    }
}
