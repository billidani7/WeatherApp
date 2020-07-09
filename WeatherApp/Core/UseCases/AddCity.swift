//
//  AddCity.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

typealias AddCityUseCaseCompletionHandler = (_ cities: Result<City>) -> Void

protocol AddCityUseCase {
    func add(parameters: AddCityParameters, completionHandler: @escaping AddCityUseCaseCompletionHandler)
}

// This class is used across all layers - Core, UI and Network
// It's not violating any dependency rules.
// However it might make sense for each layer do define it's own input parameters so it can be used independently of the other layers.
struct AddCityParameters {
    var id: String
    var name: String
    var country: String
    var region: String
    var latitude: String
    var longitude: String
}


class AddCityUseCaseImplementation: AddCityUseCase {
    let citiesGateway: CitiesGateway
    
    init(citiesGateway: CitiesGateway) {
        self.citiesGateway = citiesGateway
    }
    
    
    // MARK: - AddCityUseCase
    
    func add(parameters: AddCityParameters, completionHandler: @escaping AddCityUseCaseCompletionHandler) {
        self.citiesGateway.add(parameters: parameters) { result in
            completionHandler(result)
        }
    }
    
    
}
