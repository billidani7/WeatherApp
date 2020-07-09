//
//  CitiesGateway.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

typealias FetchCitiesEntityGatewayCompletionHandler = (_ cities: Result<[City]>) -> Void
typealias AddCityEntityGatewayCompletionHandler = (_ cities: Result<City>) -> Void
typealias DeleteCityEntityGatewayCompletionHandler = (_ cities: Result<Void>) -> Void

protocol CitiesGateway {
    func fetchCities(completionHandler: @escaping FetchCitiesEntityGatewayCompletionHandler)
    
    func add(parameters: AddCityParameters,
             completionHandler: @escaping AddCityEntityGatewayCompletionHandler)
    
    func delete(city: City, completionHandler: @escaping DeleteCityEntityGatewayCompletionHandler)
}
