//
//  SearchCity.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 2/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

typealias SearchCitysUseCaseCompletionHandler = (_ cities: Result<[City]>) -> Void

protocol SearchCityUseCase {
    func searchCity(query text: String, completionHandler: @escaping SearchCitysUseCaseCompletionHandler)
}

class SearchCityUseCaseImplementation: SearchCityUseCase {
    let apiWeatherGateway: ApiWeatherGateway
    
    init(apiWeatherGateway: ApiWeatherGateway) {
        self.apiWeatherGateway = apiWeatherGateway
    }
    
    //MARK: - SearchCityUseCase
    
    func searchCity(query text: String, completionHandler: @escaping SearchCitysUseCaseCompletionHandler) {
        //worldweatheronline.com API supports search above 3 character long strings
        guard text.count > 2 else {
            completionHandler(.success([]))
            return
        }
        
        apiWeatherGateway.searchCities(withName: text) { result in
            completionHandler(result)
        }
    }
    
}
