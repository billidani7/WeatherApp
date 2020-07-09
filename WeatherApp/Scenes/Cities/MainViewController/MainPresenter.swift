//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol MainView: class {
    //func refreshMainView()
    func loadNewAddedCity(cityName name: String)
    func initiliazePageContoller()
    func showEmptyScreen()
    func updateCityLabel(withCityName name: String)
    func displayCitiesRetrievalError(title: String, message: String)
    func updatePageControllerAfterDeleting(deletedCityId: String)
    //func checkIfDeletedCityIsCurrentlyPressented(deletedCityId: String)
}

protocol MainPresenter {
    var numberOfCities: Int { get }
    var router: MainViewRouter { get }
    var loadedControllers: [CityViewController] { get }
    func loadNextCity() -> CityViewController?
    func addButtonPressed()
    func viewDidLoad()
    func loadCity(withIndex index: Int)
    //func configure(cell: CityCellView, forRow row: Int)
}

class MainPresenterImplementation: MainPresenter, ResultsPresenterDelegate, CitiesPresenterDelegate {
    fileprivate weak var view: MainView?
    fileprivate let displayCitiesUseCase: DisplayCitiesUseCase
    internal let router: MainViewRouter
    
    var cities = [City]()
    
    var loadedControllers: [CityViewController]
    
    var numberOfCities: Int {
        return cities.count
    }
    
    init(view: MainView, displayCitiesUseCase: DisplayCitiesUseCase, router: MainViewRouter) {
        self.view = view
        self.displayCitiesUseCase = displayCitiesUseCase
        self.router = router
        self.loadedControllers = []
    }
    
    // MARK: - MainPresenter
    
    func addButtonPressed() {
        router.presentAddCity(resultsPresenterDelegate: self, citiesPresenterDelegate: self)
    }
    
    func viewDidLoad() {
        self.displayCitiesUseCase.displayCities { (result) in
            switch result {
            case let .success(cities):
                print("success cities = \(cities)")
                self.handleCitiesReceived(cities)
            case let .failure(error):
                print("error = error = \(error)")
                self.handleCitiesError(error)
            }
        }
    }
    
    
    func loadNextCity() -> CityViewController? {
        
        let indexToLoad = loadedControllers.count - 1
        guard indexToLoad < self.cities.count else{
            return nil
        }
        
        let cityViewController = CityViewController.instantiate(city: self.cities[indexToLoad])
        
        loadedControllers.append(cityViewController)
        
        view?.updateCityLabel(withCityName: self.cities[indexToLoad].name)
        
        return cityViewController
    }
    
    func loadCity(withIndex index: Int) {
        view?.updateCityLabel(withCityName: self.cities[index].name)
    }
    
    
    // MARK: - ResultsPresenterDelegate
    
       func addCityPresenter(_ presenter: ResultsPresenter, didAdd city: City) {
           presenter.router.dismiss()
           cities.append(city)
           
           let cityViewController = CityViewController.instantiate(city: city)
           loadedControllers.append(cityViewController)
           
           if loadedControllers.count == 1 { //This is the first city added
               view?.initiliazePageContoller()
               view?.updateCityLabel(withCityName: city.name)
           }else{
               view?.loadNewAddedCity(cityName: city.name)
           }
       }
       
       func addCityPresenterCancel(presenter: ResultsPresenter) {
           presenter.router.dismiss()
       }
    
    // MARK: - CitiesPresenterDelegate
    
    func didDelete(city: City) {
        print("didDelete!!!")
        
        if let indexToBeDeleted = loadedControllers.firstIndex(
            where: { return $0.city?.id == city.id } )
        
        {
            print("loadedControllers indexToBeDeleted = \(indexToBeDeleted)")
            loadedControllers.remove(at: indexToBeDeleted)
        }
        
        if let indexToBeDeleted2 = cities.firstIndex(
            where: { return $0.id == city.id } )
        
        {
            print("cities indexToBeDeleted = \(indexToBeDeleted2)")
            cities.remove(at: indexToBeDeleted2)
        }
        
        view?.updatePageControllerAfterDeleting(deletedCityId: city.id)
    }
    
    // MARK: - Private
    
    fileprivate func handleCitiesReceived(_ cities: [City]) {
        self.cities = cities
        
        guard numberOfCities > 0 else {
            
            view?.showEmptyScreen()
            return
        }
        guard numberOfCities > 0, loadedControllers.count < numberOfCities  else {
            return
        }
        
        var citiesToLoad = 2 //We dont load all the cities immediately. we prefer lazy loading as scrolling
        if numberOfCities == 1 {
            citiesToLoad = 1
        }
        
        for i in 0 ..< citiesToLoad {
            let cityViewController = CityViewController.instantiate(city: cities[i])
    
            loadedControllers.append(cityViewController)
        }
        
        view?.initiliazePageContoller()
        view?.updateCityLabel(withCityName: cities[0].name)
        
    }
    
    fileprivate func handleCitiesError(_ error: Error) {
        // Here we could check the error code and display a localized error message
        view?.displayCitiesRetrievalError(title: "Error", message: error.localizedDescription)
    }
    
}
