//
//  ApiSearchCity.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 2/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct ApiSearchCity: Decodable {
    let searchAPI: SearchAPI

    enum CodingKeys: String, CodingKey {
        case searchAPI = "search_api"
    }
}

// MARK: - SearchAPI
struct SearchAPI: Decodable {
    let result: [CityResult]
}

// MARK: - CityResult
struct CityResult: Decodable {
    let areaName, country, region: [AreaName]
    let latitude, longitude, population: String
    let weatherURL: [AreaName]

    enum CodingKeys: String, CodingKey {
        case areaName, country, region, latitude, longitude, population
        case weatherURL = "weatherUrl"
    }
}

// MARK: - AreaName
struct AreaName: Decodable {
    let value: String
}


extension CityResult {
    var city: City {
        return City(id: NSUUID().uuidString,
                    name: self.areaName.first?.value ?? "",
                    country: self.country.first?.value ?? "",
                    region: self.region.first?.value ?? "",
                    latitude: self.latitude,
                    longitude: self.longitude
        )
    }
}
