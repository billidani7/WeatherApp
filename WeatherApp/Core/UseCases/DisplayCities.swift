//
//  DisplayCitiesList.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


typealias DisplayCitiesUseCaseCompletionHandler = (_ cities: Result<[City]>) -> Void

protocol DisplayCitiesUseCase {
    func displayCities(completionHandler: @escaping DisplayCitiesUseCaseCompletionHandler)
}

class DisplayCitiesUseCaseImplementation: DisplayCitiesUseCase {
    let citiesGateway: CitiesGateway
    
    init(citiesGateway: CitiesGateway) {
        self.citiesGateway = citiesGateway
    }
    
    
    //MARK: - DisplayCitiesUseCase
    
    func displayCities(completionHandler: @escaping DisplayCitiesUseCaseCompletionHandler) {
        self.citiesGateway.fetchCities { result in
            // Do any additional processing & after that call the completion handler
            completionHandler(result)
        }
    }
}
