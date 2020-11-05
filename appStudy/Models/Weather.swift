//
//  Weather.swift
//  appStudy
//
//  Created by Clement  Wekesa on 04/11/2020.
//

import Foundation

struct Weather: Codable {
    let lat: String
    let lon: String
    let timeZone: String
    let current: Current
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
}

struct Daily: Codable {
    let sunrise: String
    let sunset: String
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let evening: Double
    let morning: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let evening: Double
    let morning: Double
}
