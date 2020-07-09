//
//  ApiCityWeather.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let configData = try? newJSONDecoder().decode(ApiCityWeather.self, from: jsonData)

import Foundation

// MARK: - ConfigData
struct ApiCityWeather: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let request: [Request]
    let currentCondition: [CurrentCondition]
    let weather: [WeatherElement]

    enum CodingKeys: String, CodingKey {
        case request
        case currentCondition = "current_condition"
        case weather
    }
}

// MARK: - CurrentCondition
struct CurrentCondition: Codable {
    let observationTime, tempC, tempF, weatherCode, isDayTime: String
    let weatherIconURL, weatherDesc: [WeatherDesc]
    let windspeedMiles, windspeedKmph, winddirDegree, winddir16Point: String
    let precipMM, precipInches, humidity, visibility: String
    let visibilityMiles, pressure, pressureInches, cloudcover: String
    let feelsLikeC, feelsLikeF, uvIndex: String

    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case tempC = "temp_C"
        case tempF = "temp_F"
        case isDayTime = "isdaytime"
        case weatherCode
        case weatherIconURL = "weatherIconUrl"
        case weatherDesc, windspeedMiles, windspeedKmph, winddirDegree, winddir16Point, precipMM, precipInches, humidity, visibility, visibilityMiles, pressure, pressureInches, cloudcover
        case feelsLikeC = "FeelsLikeC"
        case feelsLikeF = "FeelsLikeF"
        case uvIndex
    }
}

// MARK: - Weather
struct WeatherDesc: Codable {
    let value: String
}

// MARK: - Request
struct Request: Codable {
    let type, query: String
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let date: String
    let astronomy: [Astronomy]
    let maxtempC, maxtempF, mintempC, mintempF: String
    let avgtempC, avgtempF, totalSnowCM, sunHour: String
    let uvIndex: String
    let hourly: [Hourly]

    enum CodingKeys: String, CodingKey {
        case date, astronomy, maxtempC, maxtempF, mintempC, mintempF, avgtempC, avgtempF
        case totalSnowCM = "totalSnow_cm"
        case sunHour, uvIndex, hourly
    }
}

// MARK: - Astronomy
struct Astronomy: Codable {
    let sunrise, sunset, moonrise, moonset: String
    let moonPhase, moonIllumination: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time, utCdate, utCtime, tempC, isDayTime: String
    let tempF, windspeedMiles, windspeedKmph, winddirDegree: String
    let winddir16Point, weatherCode: String
    let weatherIconURL, weatherDesc: [WeatherDesc]
    let precipMM, precipInches, humidity, visibility: String
    let visibilityMiles, pressure, pressureInches, cloudcover: String
    let heatIndexC, heatIndexF, dewPointC, dewPointF: String
    let windChillC, windChillF, windGustMiles, windGustKmph: String
    let feelsLikeC, feelsLikeF, chanceofrain, chanceofremdry: String
    let chanceofwindy, chanceofovercast, chanceofsunshine, chanceoffrost: String
    let chanceofhightemp, chanceoffog, chanceofsnow, chanceofthunder: String
    let uvIndex: String

    enum CodingKeys: String, CodingKey {
        case time
        case utCdate = "UTCdate"
        case utCtime = "UTCtime"
        case isDayTime = "isdaytime"
        case tempC, tempF, windspeedMiles, windspeedKmph, winddirDegree, winddir16Point, weatherCode
        case weatherIconURL = "weatherIconUrl"
        case weatherDesc, precipMM, precipInches, humidity, visibility, visibilityMiles, pressure, pressureInches, cloudcover
        case heatIndexC = "HeatIndexC"
        case heatIndexF = "HeatIndexF"
        case dewPointC = "DewPointC"
        case dewPointF = "DewPointF"
        case windChillC = "WindChillC"
        case windChillF = "WindChillF"
        case windGustMiles = "WindGustMiles"
        case windGustKmph = "WindGustKmph"
        case feelsLikeC = "FeelsLikeC"
        case feelsLikeF = "FeelsLikeF"
        case chanceofrain, chanceofremdry, chanceofwindy, chanceofovercast, chanceofsunshine, chanceoffrost, chanceofhightemp, chanceoffog, chanceofsnow, chanceofthunder, uvIndex
    }
}

extension ApiCityWeather {
    
    var weather: Weather {
        
        let current = WeatherCondition(
            utcDate: WeatherCondition.getUtcDateString(),
            utcTime: "000", isDayTime: self.data.currentCondition.first?.isDayTime ?? "false",
                                tempF: self.data.currentCondition.first?.tempF ?? "-",
                                tempC: self.data.currentCondition.first?.tempC ?? "-",
                                weatherCode: Int(self.data.currentCondition.first?.weatherCode ?? "0")! ,
                                weatherDesc: self.data.currentCondition.first?.weatherDesc.first?.value ?? "-"
        )
                
        var fivedayForecast : [DayWeather] = []
        
        //For each Day
        for apiWeatherElement in self.data.weather {
            
            var hourly: [WeatherCondition] = []
            
            //For each hour of the day
            for apiHourly in apiWeatherElement.hourly {
                
                let hourWeather = WeatherCondition(
                                        utcDate: apiHourly.utCdate,
                                        utcTime: apiHourly.utCtime,
                                        isDayTime: apiHourly.isDayTime,
                                        tempF: apiHourly.tempF,
                                        tempC: apiHourly.tempC,
                                        weatherCode: Int(apiHourly.weatherCode) ?? 0,
                                        weatherDesc: apiHourly.weatherDesc.first?.value ?? "-"
                )
            
                hourly.append(hourWeather)
            }
            
            let dayForecast = DayWeather(dateString: apiWeatherElement.date,
                                         maxtempC: apiWeatherElement.maxtempC,
                                         mintempC: apiWeatherElement.mintempC,
                                         hourlyCondition: hourly
            )
            fivedayForecast.append(dayForecast)
        }
        
        
        return Weather(currentCondition: current, fiveDayForecast: fivedayForecast)
    }

}
