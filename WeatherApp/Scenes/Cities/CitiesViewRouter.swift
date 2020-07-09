//
//  CitiesViewRouter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 1/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit


protocol CitiesViewRouter: ViewRouter {
    //func presentDetailsView(for city: City)
    //func presentAddCity(addCityPresenterDelegate: AddCityPresenterDelegate)
}


class CitiesViewRouterImplementation: CitiesViewRouter {
    
    fileprivate weak var citiesTableViewController: CitiesTableViewController?
    //fileprivate weak var addCityPresenterDelegate: AddCityPresenterDelegate?
    fileprivate var city: City!
    
    init(citiesTableViewController: CitiesTableViewController) {
        self.citiesTableViewController = citiesTableViewController
    }
    
}
