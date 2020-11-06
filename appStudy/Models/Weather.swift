//
//  Weather.swift
//  appStudy
//
//  Created by Clement  Wekesa on 04/11/2020.
//

import Foundation

struct Weather: Codable {
    let lat: Double
    let lon: Double
    let timeZone: String?
    let timezone_offset: Double
    let current: Current
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
//    let rain: Rain
}

//struct Rain: Codable {
//    let rain: Double
//
//    enum CodingKeys: String, CodingKey  {
//        case rain = "1h"
//    }
//}

struct Daily: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temp
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
