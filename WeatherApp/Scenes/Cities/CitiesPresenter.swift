//
//  CitiesPresenter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol CitiesView: class {
    func refreshCitiesView()
    func displayCitiesRetrievalError(title: String, message: String)
    func displayCitiesDeleteError(title: String, message: String)
    func deleteAnimated(row: Int)
    func endEditing()
}

// It would be fine for the cell view to declare a CityCellView property and have it configure itself
// Using this approach makes the view even more passive/dumb
protocol CityCellView {
    func display(title: String)
    //func display(author: String)
    //func display(releaseDate: String)
}
protocol CitiesPresenterDelegate: class {
    func didDelete(city: City)
}

protocol CitiesPresenter {
    var numberOfCities: Int { get }
    var router: CitiesViewRouter { get }
    //func addButtonPressed()
    func viewDidLoad()
    func configure(cell: CityCellView, forRow row: Int)
    func canEdit(row: Int) -> Bool
    func titleForDeleteButton(row: Int) -> String
    func deleteButtonPressed(row: Int)
}

class CitiesPresenterImplementation: CitiesPresenter {
    fileprivate weak var view: CitiesView?
    fileprivate let displayCitiesUseCase: DisplayCitiesUseCase
    fileprivate let deleteCityUseCase: DeleteCityUseCase
    fileprivate weak var delegate: CitiesPresenterDelegate?
    internal let router: CitiesViewRouter
    
    var cities = [City]()
    
    var numberOfCities: Int {
        return cities.count
    }
    
    init(view: CitiesView, displayCitiesUseCase: DisplayCitiesUseCase, deleteCityUseCase: DeleteCityUseCase, delegate: CitiesPresenterDelegate?, router: CitiesViewRouter) {
        self.view = view
        self.displayCitiesUseCase = displayCitiesUseCase
        self.deleteCityUseCase = deleteCityUseCase
        self.delegate = delegate
        self.router = router
        
        registerForDeleteCityNotification()
    }
    
    // MARK: - CitiesPresenter
    
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
    
    func configure(cell: CityCellView, forRow row: Int) {
        let city = cities[row]
        cell.display(title: city.name)
    }
    
    func canEdit(row: Int) -> Bool {
        return true
    }
    
    func titleForDeleteButton(row: Int) -> String {
        return "Delete City"
    }
    
    func deleteButtonPressed(row: Int) {
        view?.endEditing()
        
        let city = cities[row]
        print("city = \(city.name)")
        //self.handleCityDeleted(city: city)
        
        deleteCityUseCase.delete(city: city) { (result) in
            switch result {
            case .success():
                self.handleCityDeleted(city: city)
            case let .failure(error):
                self.handleCityDeleteError(error)
            }
        }
    }
    
//    func addButtonPressed() {
//        router.presentAddCity(addCityPresenterDelegate: self)
//    }
    
    // MARK: - ResultsPresenterDelegate
    
//    func addCityPresenter(_ presenter: ResultsPresenter, didAdd city: City) {
//        print("addCityPresenter didAdd")
//        presenter.router.dismiss()
//    }
//    
//    func addCityPresenterCancel(presenter: ResultsPresenter) {
//        print("addCityPresenter Cancel")
//    }
    
    //MARK: - AddCityPresenterDelegate
    
//    func addCityPresenter(_ presenter: AddCityPresenter, didAdd city: City) {
//        presenter.router.dismiss()
//        cities.append(city)
//        view?.refreshCitiesView()
//    }
//
//    func addCityPresenterCancel(presenter: AddCityPresenter) {
//         presenter.router.dismiss()
//    }
    
    
    
    // MARK: - Private
    
    fileprivate func handleCitiesReceived(_ cities: [City]) {
        self.cities = cities
        view?.refreshCitiesView()
    }
    
    fileprivate func handleCitiesError(_ error: Error) {
        // Here we could check the error code and display a localized error message
        view?.displayCitiesRetrievalError(title: "Error", message: error.localizedDescription)
    }
    
    fileprivate func registerForDeleteCityNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDeleteCityNotification),
                                               name: DeleteCityUseCaseNotifications.didDeleteCity,
                                               object: nil)
    }
    
    @objc fileprivate func didReceiveDeleteCityNotification(_ notification: Notification) {
        if let city = notification.object as? City {
            handleCityDeleted(city: city)
        }
    }
    
    fileprivate func handleCityDeleted(city: City) {
        // The city might have already be deleted due to the notification response
        if let row = cities.firstIndex(of: city) {
            cities.remove(at: row)
            view?.deleteAnimated(row: row)
            delegate?.didDelete(city: city)
        }
    }
    
    fileprivate func handleCityDeleteError(_ error: Error) {
        // Here we could check the error code and display a localized error message
        view?.displayCitiesDeleteError(title: "Error", message: error.localizedDescription)
    }
    
}
