//
//  CoreDataCity.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

// It's best to decouple the application / business logic from the persistence framework
// That's why CoreDataCity - which is a NSManagedObjectModel subclass is converted into a City entity
extension CoreDataCity {
    
    var city: City {
        return City(id: id ?? "", name: name ?? "",
                    country: country ?? "",
                    region: region ?? "",
                    latitude: latitude ?? "",
                    longitude: longitude ?? ""
        )
    }
    
    func populate(with parameters: AddCityParameters)  {
        // Normally this id should be used at some point during the sync with the API backend
        id = NSUUID().uuidString
        name = parameters.name
        country = parameters.country
        region = parameters.region
        latitude = parameters.latitude
        longitude = parameters.longitude
    }
    
    func populate(with city: City) {
        id = city.id
        name = city.name
        country = city.country
        region = city.region
        latitude = city.latitude
        longitude = city.longitude
    }
    
    
}
