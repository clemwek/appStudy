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

        if let place = place {
            let net = NetworkManager.shared
            let lon = place.lon
            let lat = place.lat
            net.fetch(lat: lat, lon: lon) { (status, weather) in
                // Work display the data
                print(weather)
                self.weather = weather
            }
        }
    }
}
