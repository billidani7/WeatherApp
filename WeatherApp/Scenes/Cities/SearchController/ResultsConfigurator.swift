//
//  ResultsConfigurator.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 7/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


protocol ResultsConfigurator {
    func configure(resultsTableController: ResultsTableController, citiesTableController: CitiesTableViewController?)
}

class ResultsConfiguratorImplementation: ResultsConfigurator {
    var resultsPresenterDelegate: ResultsPresenterDelegate?
    
    init(resultsPresenterDelegate: ResultsPresenterDelegate?) {
        self.resultsPresenterDelegate = resultsPresenterDelegate
    }
    
    func configure(resultsTableController: ResultsTableController, citiesTableController: CitiesTableViewController?) {
        
        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        let coreDataCitiesGateway = CoreDataCitiesGateway(viewContext: viewContext)
        
        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default, completionHandlerQueue: OperationQueue.main)
        let apiWeatherGateway = ApiWeatherGatewayImplementation(apiClient: apiClient)
        
        let citiesGateway = CacheCitiesGateway(localPersistenceCitiesGateway: coreDataCitiesGateway)
        
        let addCityUseCase = AddCityUseCaseImplementation(citiesGateway: citiesGateway)
        let searchCityUseCase = SearchCityUseCaseImplementation(apiWeatherGateway: apiWeatherGateway)
        
        let router = ResultsViewRouterImplementation(citiesTableController: citiesTableController)
        
        let presenter = ResultsPresenterImplementation(view: resultsTableController, addCityUseCase: addCityUseCase, searchCityUseCase: searchCityUseCase, delegate: resultsPresenterDelegate, router: router)
        
        resultsTableController.presenter = presenter
    }
}
