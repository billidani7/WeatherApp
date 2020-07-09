//
//  CitiesConfigurator.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 1/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol CitiesConfigurator {
    func configure(citiesTableViewController: CitiesTableViewController)
}

class CitiesConfiguratorImplementation: CitiesConfigurator {
    
    var citiesPresenterDelegate: CitiesPresenterDelegate?
    
    init(citiesPresenterDelegate: CitiesPresenterDelegate?) {
        self.citiesPresenterDelegate = citiesPresenterDelegate
    }
    
    func configure(citiesTableViewController: CitiesTableViewController) {
        
        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        let coreDataCitiesGateway = CoreDataCitiesGateway(viewContext: viewContext)
        
        let citiesGateway = CacheCitiesGateway(localPersistenceCitiesGateway: coreDataCitiesGateway)
        
        
        let displayCitiesUseCase = DisplayCitiesUseCaseImplementation(citiesGateway: citiesGateway)
        let deleteCityUseCase = DeleteCityUseCaseCaseImplementation(citiesGateway: citiesGateway)
        
        let router = CitiesViewRouterImplementation(citiesTableViewController: citiesTableViewController)
        let presenter = CitiesPresenterImplementation(view: citiesTableViewController, displayCitiesUseCase: displayCitiesUseCase, deleteCityUseCase: deleteCityUseCase, delegate: citiesPresenterDelegate, router: router)
        
        citiesTableViewController.presenter = presenter
    }
    
    
}
