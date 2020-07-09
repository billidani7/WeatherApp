//
//  DeleteCity.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 8/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

typealias DeleteCityUseCaseCompletionHandler = (_ cities: Result<Void>) -> Void

struct DeleteCityUseCaseNotifications {
    // Notification sent when a city is deleted having the city set to the notification object
    static let didDeleteCity = Notification.Name("didDeleteCityNotification")
}

protocol DeleteCityUseCase {
    
    func delete(city: City, completionHandler: @escaping DeleteCityUseCaseCompletionHandler)
}

class DeleteCityUseCaseCaseImplementation: DeleteCityUseCase {
    
    let citiesGateway: CitiesGateway
    
    init(citiesGateway: CitiesGateway) {
        self.citiesGateway = citiesGateway
    }
    
    // MARK: - DeleteCityUseCase
    
    func delete(city: City, completionHandler: @escaping (Result<Void>) -> Void) {
        self.citiesGateway.delete(city: city) { (result) in
            // Do any additional processing & after that call the completion handler
            // In this case we will broadcast a notification
            switch result {
            case .success():
                NotificationCenter.default.post(name: DeleteCityUseCaseNotifications.didDeleteCity, object: city)
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
}
