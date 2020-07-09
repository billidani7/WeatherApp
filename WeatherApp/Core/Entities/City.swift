//
//  City.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct City {
    var id: String
    var name: String
    var country: String
    var region: String
    var latitude: String
    var longitude: String
    var weather: Weather?
}

extension City: Equatable {}

func == (lhs: City, rhs: City) -> Bool {
    return lhs.id == rhs.id
}
