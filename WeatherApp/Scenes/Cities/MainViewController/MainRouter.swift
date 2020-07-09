//
//  MainRouter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 5/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit


protocol MainViewRouter: ViewRouter {
    func presentAddCity(resultsPresenterDelegate: ResultsPresenterDelegate, citiesPresenterDelegate: CitiesPresenterDelegate)
}


class MainViewRouterImplementation: MainViewRouter {
    fileprivate weak var mainViewController: MainViewController?
    fileprivate weak var resultsPresenterDelegate: ResultsPresenterDelegate?
    fileprivate weak var citiesPresenterDelegate: CitiesPresenterDelegate?
    //fileprivate var city: City!
    
    init(mainViewController: MainViewController) {
        self.mainViewController = mainViewController
    }
    
    
    
    // MARK: - MainViewRouter
    
    func presentAddCity(resultsPresenterDelegate: ResultsPresenterDelegate, citiesPresenterDelegate: CitiesPresenterDelegate){
        self.resultsPresenterDelegate = resultsPresenterDelegate
        self.citiesPresenterDelegate = citiesPresenterDelegate
        mainViewController?.performSegue(withIdentifier: "MainSceneToCitiesSceneSegue", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let citiesTableViewController = navigationController.topViewController as? CitiesTableViewController
        {
            citiesTableViewController.configurator =
                CitiesConfiguratorImplementation(citiesPresenterDelegate: citiesPresenterDelegate)
            citiesTableViewController.resultsPresenterDelegate = self.resultsPresenterDelegate

        }
    }
    
    
    
}
