//
//  ResultsViewRouter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 7/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


protocol ResultsViewRouter: ViewRouter {
    func dismiss()
}

class ResultsViewRouterImplementation: ResultsViewRouter {
    fileprivate weak var citiesTableController: CitiesTableViewController?
    
    init(citiesTableController: CitiesTableViewController?) {
        
        self.citiesTableController = citiesTableController
    }
    
    //MARK: - ResultsViewRouter
    
    func dismiss() {
        citiesTableController?.searchController.isActive = false
        citiesTableController?.dismiss(animated: true, completion: nil)
    }
    
    
}
