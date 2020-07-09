//
//  CacheCitiesGateway.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

// Discussion:
// In case we want to sync the persisted cities with our backend server (API)
// Maybe it makes sense to perform all the operations locally and only after that make the API call
// to sync the local content with our backend (API).
// If that's the case we will only have to change this class and the use case won't be impacted
class CacheCitiesGateway: CitiesGateway {
    let localPersistenceCitiesGateway: LocalPersistenceCitiesGateway
    
    init(localPersistenceCitiesGateway: LocalPersistenceCitiesGateway) {
        self.localPersistenceCitiesGateway = localPersistenceCitiesGateway
    }
    
    // MARK: - CitiesGateway
    
    func fetchCities(completionHandler: @escaping (Result<[City]>) -> Void) {
        
        localPersistenceCitiesGateway.fetchCities(completionHandler: completionHandler)
    }
    
    func add(parameters: AddCityParameters, completionHandler: @escaping AddCityEntityGatewayCompletionHandler) {
        //We could sync here the new city with our backend right after the local persistence
        self.localPersistenceCitiesGateway.add(parameters: parameters, completionHandler: completionHandler)
    }
    
    func delete(city: City, completionHandler: @escaping DeleteCityEntityGatewayCompletionHandler) {
        self.localPersistenceCitiesGateway.delete(city: city, completionHandler: completionHandler)
    }

    
    // MARK: - Private
    
//    fileprivate func handleAddCityApiResult(_ result: Result<City>, parameters: AddCityParameters, completionHandler: @escaping (Result<City>) -> Void) {
//        switch result {
//        case let .success(city):
//            self.localPersistenceCitiesGateway.add(city: city)
//            completionHandler(result)
//        case .failure(_):
//            self.localPersistenceCitiesGateway.add(parameters: parameters, completionHandler: completionHandler)
//        }
//    }
//
//    fileprivate func handleFetchCitiesApiResult(_ result: Result<[City]>, completionHandler: @escaping (Result<[City]>) -> Void){
//        switch result {
//        case let .success(cities):
//            localPersistenceCitiesGateway.save(cities: cities)
//        case .failure(_):
//            localPersistenceCitiesGateway.fetchCities(completionHandler: completionHandler)
//        }
//
//    }
}
