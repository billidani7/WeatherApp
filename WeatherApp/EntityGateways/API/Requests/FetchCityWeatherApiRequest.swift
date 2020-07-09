//
//  FetchCityWeatherApiRequest.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

//http://api.worldweatheronline.com/premium/v1/weather.ashx?key=55a70ceadb324b6794a80559203006&q=37.980,23.716&format=json&extra=utcDateTime&num_of_days=5&mca=no
struct FetchCityWeatherApiRequest: ApiRequest {
    var city: City
    
    init(forCity city: City) {
        self.city = city
    }
    
    var urlRequest: URLRequest {
        
        let baseURL = URL(string: "https://api.worldweatheronline.com/premium/v1")!
        
        let queryURL = baseURL.appendingPathComponent("/weather.ashx")
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
           URLQueryItem(name: "key", value: "55a70ceadb324b6794a80559203006"),
           URLQueryItem(name: "q", value: "\(city.latitude),\(city.longitude)"),
           URLQueryItem(name: "format", value: "json"),
           URLQueryItem(name: "extra", value: "utcDateTime,isDayTime"),
           URLQueryItem(name: "num_of_days", value: "5"),
           URLQueryItem(name: "mca", value: "no"),
           URLQueryItem(name: "tp", value: "1")
           //
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return request
    }
}
