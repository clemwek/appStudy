//
//  CityViewController.swift
//  appStudy
//
//  Created by Clement  Wekesa on 05/11/2020.
//

import UIKit

class CityViewController: UIViewController {
    
    var place: Places?
    var weather: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let place = place {
            let net = NetworkManager.shared
            let lon = place.lon
            let lat = place.lat
            net.fetch(lat: lat, lon: lon) { (status, weather) in
                self.weather = weather
            }
        }
    }
}
