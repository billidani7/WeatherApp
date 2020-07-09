//
//  ApiWeatherGateway.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 2/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


protocol ApiWeatherGateway {
    func searchCities(withName cityName: String, completionHandler: @escaping (Result<[City]>) -> Void)
    func fetchWeather(forCity city: City, completionHandler: @escaping (Result<Weather>) -> Void)
}

class ApiWeatherGatewayImplementation: ApiWeatherGateway {
    
    let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    //MARK: - ApiWeatherGateway
    
    func searchCities(withName cityName: String, completionHandler: @escaping (Result<[City]>) -> Void) {
        let searchCityRequest = SearchCityApiRequest(withName: cityName)
        apiClient.execute(request: searchCityRequest) { (result: Result<ApiResponse<ApiSearchCity>>) in
            switch result {
            case let .success(response):
                let cities = response.entity.searchAPI.result.map{ return $0.city }
                print("ApiWeatherGateway searchCities = \(cities)")
                completionHandler(.success(cities))
            case let .failure(error):
                print("ApiWeatherGateway searchCities ERROR = \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }
        
    }
    
    func fetchWeather(forCity city: City, completionHandler: @escaping (Result<Weather>) -> Void) {
        let fetchCityWeatherRequest = FetchCityWeatherApiRequest(forCity: city)
        
        apiClient.execute(request: fetchCityWeatherRequest) { (result: Result<ApiResponse<ApiCityWeather>>) in
            switch result{
            case let .success(responce):
                
                //let currentWeather = responce.entity.currentWeather
                //let hourlyWeather = responce.entity.hourly
                completionHandler(.success(responce.entity.weather))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }

}
