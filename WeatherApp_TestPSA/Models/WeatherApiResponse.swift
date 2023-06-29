//
//  WeatherApiResponse.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import Foundation

struct WeatherApiResponse: Decodable{
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Double
    let sys: Sys
}

// MARK: - Weather
struct Weather: Decodable {
    let description, icon: String
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Rain
struct Rain: Codable {
    let lastHour: Double
    
    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let lastHour: Double
    
    enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Double
}
