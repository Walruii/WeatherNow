//
//  WeatherData.swift
//  WeatherNow
//
//  Created by Inderpreet Bhatti on 17/10/24.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main : Codable {
    let temp: Double
}

struct Weather : Codable {
    let description: String
    let id: Int
}
