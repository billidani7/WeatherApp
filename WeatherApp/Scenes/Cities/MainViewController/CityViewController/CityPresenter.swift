//
//  CityPresenter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol CityView: class {
    func refreshView()
}


protocol CityPresenter {
    var city: City { get }
    func viewDidLoad()
}

//Add AddCityPresenterDelegate
class CityPresenterImplementation: CityPresenter {
    
    fileprivate weak var view: CityView?
    fileprivate let fetchCityWeatherUseCase: FetchCityWeatherUseCase
    internal var city: City
    
    
    init(view: CityView, city: City, fetchCityWeatherUseCase: FetchCityWeatherUseCase) {
        self.view = view
        self.fetchCityWeatherUseCase = fetchCityWeatherUseCase
        self.city = city
        //self.router = router
    }
    
    // MARK: - CityPresenter
    
    func viewDidLoad() {
        fetchCityWeatherUseCase
            .fetchCityWeather(forCity: city) { (result) in
                switch result {
                case let .success(cityWeather):
                    
                    self.handleWeatherReceived(cityWeather)
                case let .failure(error):
                    print("CityPresenterImplementation error = \(error)")
                }
        }
    }
    
    // MARK: - Private
    
    fileprivate func handleWeatherReceived(_ weather: Weather) {
        var weatherData = weather
        
        //For the same day forecast, we should remove those entries before the current time
        if let todayHourlyForecast = weatherData.fiveDayForecast.first?.hourlyCondition {
            let currentDate = Date()
            
            let filtered = todayHourlyForecast.filter{ hourlyWeather in
                return hourlyWeather.dateObject >= currentDate
            }
            
            //If filtered isEmpty, it means that you open the app between 23:00 - 00:00
            if filtered.isEmpty {
                weatherData.fiveDayForecast[0].hourlyCondition = [todayHourlyForecast.last!]
            }else{
                weatherData.fiveDayForecast[0].hourlyCondition = filtered
            }
        }
        
        self.city.weather = weatherData
        view?.refreshView()
    }
    
    
}
