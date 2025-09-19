//
//  WeatherModels.swift
//  AppLabTestiOS
//
//  Created by M Tayyab on 19/09/2025.
//

import Foundation

// MARK: - Weather Response Models
struct WeatherResponse: Codable {
    let response: ResponseData

    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }
}

struct ResponseData: Codable {
    let status: Bool
    let message: String
    let result: WeatherResult
}

struct WeatherResult: Codable {
    let city: String
    let dateTime: String
    let weatherIcon: String
    let temp: Double
    let unit: String
    let weather: String
    let feelsLike: String
    let high: Double
    let low: Double
    let humidity: String
    let windDirection: String
    let windSpeed: Double
    let windSpeedUnit: String

    enum CodingKeys: String, CodingKey {
        case city
        case dateTime
        case weatherIcon = "weather_icon"
        case temp
        case unit
        case weather
        case feelsLike = "feels_like"
        case high
        case low
        case humidity = "humi"
        case windDirection = "wind_direction"
        case windSpeed = "wind_speed"
        case windSpeedUnit = "wind_speed_unit"
    }
}

// MARK: - Weather Icon Helper
extension WeatherResult {
    /// Returns the appropriate wind direction icon name based on wind direction
    var windDirectionIcon: String {
        switch windDirection.uppercased() {
        case "N": return "ic_N"
        case "NE": return "ic_NE"
        case "E": return "ic_E"
        case "SE": return "ic_SE"
        case "S": return "ic_N"
        case "SW": return "ic_SW"
        case "W": return "ic_W"
        case "NW": return "ic_NW"
        case "NNE": return "ic_NNE"
        case "ENE": return "ic_ENE"
        case "ESE": return "ic_ESE"
        case "SSE": return "ic_SSE"
        case "SSW": return "ic_SSW"
        case "WSW": return "ic_WSW"
        case "WNW": return "ic_WNW"
        case "NNW": return "ic_NNW"
        default: return "ic_N"
        }
    }

    /// Formatted temperature string
    var formattedTemp: String {
        return "\(Int(temp))\(unit)"
    }

    /// Formatted high/low temperature string
    var formattedHighLow: String {
        return "H:\(Int(high))° L:\(Int(low))°"
    }

    /// Formatted wind speed string
    var formattedWindSpeed: String {
        return "\(windSpeed) \(windSpeedUnit)"
    }

    /// Capitalized weather description (first letter only)
    var capitalizedWeather: String {
        return weather.capitalized
    }
}
