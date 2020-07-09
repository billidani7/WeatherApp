//
//  City.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 8/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
@testable import WeatherApp

extension City {
    
    static func createCitiesArray(numberOfElements: Int = 2) -> [City] {
        var cities = [City]()
        
        for i in 0..<numberOfElements {
            let city = createCity(index: i)
            cities.append(city)
        }
        
        return cities
    }
    
    static func createCity(index: Int = 0) -> City {
        return City(id: "\(index)", name: "name \(index)", country: "Country \(index)", region: "Region \(index)", latitude: "Lat \(index)", longitude: "Lon \(index)", weather: nil)
    
    }
    
}
