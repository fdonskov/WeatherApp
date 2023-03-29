//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Федор Донсков on 28.03.2023.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
}

struct Current: Codable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC: Int
    let isDay: Int
    let condition: Condition
    let windKph: Double

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
    }
}

struct Condition: Codable {
    let text, icon: String
    let code: Int
}

struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}
