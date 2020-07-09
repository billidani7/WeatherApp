//
//  FetchCityWeather.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

typealias FetchCityWeatherUseCaseCompletionHandler = (_ weather: Result<Weather>) -> Void

protocol FetchCityWeatherUseCase {
    func fetchCityWeather(forCity city: City, completionHandler: @escaping FetchCityWeatherUseCaseCompletionHandler)
}

class FetchCityWeatherUseCaseImplementation: FetchCityWeatherUseCase {
    let apiWeatherGateway: ApiWeatherGateway
    
    init(apiWeatherGateway: ApiWeatherGateway) {
        self.apiWeatherGateway = apiWeatherGateway
    }
    
    //MARK: - FetchCityWeatherUseCase
    
    func fetchCityWeather(forCity city: City, completionHandler: @escaping FetchCityWeatherUseCaseCompletionHandler) {
        apiWeatherGateway.fetchWeather(forCity: city) { result in
            completionHandler(result)
        }
    }
}
