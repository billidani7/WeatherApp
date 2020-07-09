//
//  MainConfigurator.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 6/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol MainConfigurator {
    func configure(mainViewController: MainViewController)
}

class MainConfiguratorImplementation: MainConfigurator {
    
    func configure(mainViewController: MainViewController){
        let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
        let coreDataCitiesGateway = CoreDataCitiesGateway(viewContext: viewContext)
        let citiesGateway = CacheCitiesGateway(localPersistenceCitiesGateway: coreDataCitiesGateway)
        let displayCitiesUseCase = DisplayCitiesUseCaseImplementation(citiesGateway: citiesGateway)
        
        let router = MainViewRouterImplementation(mainViewController: mainViewController)
        
        let presenter = MainPresenterImplementation(view: mainViewController, displayCitiesUseCase: displayCitiesUseCase, router: router)
        
        mainViewController.presenter = presenter
    }
    
    
}
