//
//  SearchCityApiRequest.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 2/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct SearchCityApiRequest: ApiRequest {
    var cityName: String
    
    init(withName cityName: String) {
        self.cityName = cityName
    }
    
    var urlRequest: URLRequest {
        
        let baseURL = URL(string: "https://api.worldweatheronline.com/premium/v1")!
        
        let queryURL = baseURL.appendingPathComponent("/search.ashx")
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
           URLQueryItem(name: "key", value: "55a70ceadb324b6794a80559203006"),
           URLQueryItem(name: "query", value: cityName),
           URLQueryItem(name: "format", value: "json")
           //format=json
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return request
    }
}
