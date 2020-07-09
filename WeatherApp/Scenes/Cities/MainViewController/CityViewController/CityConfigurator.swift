//
//  CityConfigurator.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol CityConfigurator {
    func configure(cityViewController: CityViewController)
}

class CityConfiguratorImplementation: CityConfigurator {
    var city: City?
    
//    init(city: City) {
//        self.city = city
//    }
    
    func configure(cityViewController: CityViewController) {
        
        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default, completionHandlerQueue: OperationQueue.main)
        let apiWeatherGateway = ApiWeatherGatewayImplementation(apiClient: apiClient)
        
        let fetchCityWeatherUseCase = FetchCityWeatherUseCaseImplementation(apiWeatherGateway: apiWeatherGateway)
        
        
        let presenter = CityPresenterImplementation(view: cityViewController, city: cityViewController.city!, fetchCityWeatherUseCase: fetchCityWeatherUseCase)
        
        cityViewController.presenter = presenter
    }
    
    
}
