//
//  AddCityParameters.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 9/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

@testable import WeatherApp

extension AddCityParameters {
    static func createParameters() -> AddCityParameters {
        
        return AddCityParameters(id: "id", name: "name", country: "country", region: "region", latitude: "latitude", longitude: "longitude")
    }
}
