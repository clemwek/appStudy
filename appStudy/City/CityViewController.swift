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
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
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
                DispatchQueue.main.async{
                    self.updateUI()
                }
            }
        }
    }
    
    func updateUI() {
        if let weather = weather {
            day.text = formartDate(date: Date(timeIntervalSince1970: TimeInterval(weather.current.dt)))
            temp.text = String(weather.current.temp)
            humidity.text = String(weather.current.humidity)
            wind.text = String(weather.current.wind_speed)
            
            tableview.reloadData()
        }
    }
}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell") as! DailyCityTableViewCell
        if let dayWeather = weather?.daily[indexPath.row] {
            cell.day.text = String(formartDate(date: Date(timeIntervalSince1970: TimeInterval(dayWeather.dt))))
            cell.temp.text = String(dayWeather.temp.day)
            cell.humidity.text = String(dayWeather.humidity)
            cell.wind.text = String(dayWeather.wind_speed)
        }
        return cell
    }
    
    func formartDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
}
