//
//  NetworkManager.swift
//  appStudy
//
//  Created by Clement  Wekesa on 05/11/2020.
//

import Foundation


class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    let config = URLSessionConfiguration.default
    let url = "https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&exclude=hourly,daily&appid={API key}"
    
    private init() {}
    
    public func fetch(lat: Double, lon: Double, completion: @escaping (_ succes: Bool, _ data: Weather?) -> ()) {
        
        let selectedUnits = UserDefaults.standard.object(forKey: "selectedUnit")
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,alerts&units=\(String(describing: selectedUnits))&appid=91a8c03fd97b06005b83e87c5e7ca53a"
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, urlResponce, error) in
            guard
                error == nil,
                let responseData = data
            else {
                completion(false, nil)
                return
            }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: responseData)
                completion(true, weather)
            } catch {
                completion(false, nil)
            }
        }
        task.resume()
    }
}
