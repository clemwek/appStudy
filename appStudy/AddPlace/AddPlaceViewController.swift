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

class AddPlaceViewController: UIViewController, CLLocationManagerDelegate {
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
            
            if #available(iOS 10.0, *) {
                dropPinZoomIn(placemark: MKPlacemark(coordinate: location.coordinate))
            } else {
                render(location)
            }
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

extension AddPlaceViewController: UIGestureRecognizerDelegate {

    @objc
    func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let cgLocation = gestureReconizer.location(in: map)
        let coordinate = map.convert(cgLocation, toCoordinateFrom: map)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        if #available(iOS 10.0, *) {
            showAlert(place: MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate)))
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AddPlaceViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, name: String = "") {
        let newName = name == "" ? placemark.name : name
        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)
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
//            CoreDataClient.save(place: place)
        }))

        self.present(alertController, animated: true, completion: nil)
    }
}
