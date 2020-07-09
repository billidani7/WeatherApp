//
//  ResultsPresenter.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 7/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

protocol ResultsView: class {
    func displayAddCityError(title: String, message: String)
    func refreshResults()
}

protocol ResultCityCellView {
    func display(city: City)
}

// In the most simple cases (like this one) the delegate wouldn't be needed
// I added it just to highlight how two presenters would communicate
// Most of the time it's fine for the view controller to dimiss itself
protocol ResultsPresenterDelegate: class {
    func addCityPresenter(_ presenter: ResultsPresenter, didAdd city: City)
    func addCityPresenterCancel(presenter: ResultsPresenter)
}

protocol ResultsPresenter {
    var numberOfResults: Int { get }
    var router: ResultsViewRouter { get }
    func cityDidSelect(at index: Int)
    func cancelButtonPressed()
    func searchTextDidChange(searchText: String)
    func configure(cell: ResultCityCellView, forRow row: Int)
}


class ResultsPresenterImplementation: ResultsPresenter {
   
    fileprivate weak var view: ResultsView?
    fileprivate var addCityUseCase: AddCityUseCase
    fileprivate var searchCityUseCase: SearchCityUseCase
    fileprivate weak var delegate: ResultsPresenterDelegate?
    private(set) var router: ResultsViewRouter
    
    var results = [City]()
    
    var numberOfResults: Int {
        return results.count
    }

    
    init(view: ResultsView, addCityUseCase: AddCityUseCase, searchCityUseCase: SearchCityUseCase, delegate: ResultsPresenterDelegate?, router: ResultsViewRouter ) {
        self.view = view
        self.addCityUseCase = addCityUseCase
        self.searchCityUseCase = searchCityUseCase
        self.delegate = delegate
        self.router = router
    }
    
    
    func cityDidSelect(at index: Int) {
        let city = results[index]
        let cityParemeters = AddCityParameters(id: city.id,
                                                  name: city.name,
                                                  country: city.country,
                                                  region: city.region,
                                                  latitude: city.latitude,
                                                  longitude: city.longitude
        )
        
        addCityUseCase.add(parameters: cityParemeters) { result in
            switch result {
            case let .success(city):
                print("SUCCESS city = \(city)")
                self.handleCityAdded(city)
            case let .failure(error):
                print("ERROR = \(error.localizedDescription)")
            }
        }
    }
    
    func cancelButtonPressed() {
        delegate?.addCityPresenterCancel(presenter: self)
    }
    
    func searchTextDidChange(searchText: String) {
        print("ResultsPresenter searchTextDidChange = \(searchText)")
        searchCityUseCase.searchCity(query: searchText) { (result) in
            switch result {
            case let .success(cities):
                print("searchTextDidChange = \(cities)")
                self.handleResultsReceived(cities)
            case let .failure(error):
                print("searchTextDidChange ERROR = \(error.localizedDescription)")
            }
        }
    }
    
    
    func configure(cell: ResultCityCellView, forRow row: Int) {
        let city = results[row]
        cell.display(city: city)
    }
    
    // MARK: - Private
    
    fileprivate func handleCityAdded(_ city: City) {
        delegate?.addCityPresenter(self, didAdd: city)
    }
    
    fileprivate func handleAddCityError(_ error: Error) {
        // Here we could check the error code and display a localized error message
        view?.displayAddCityError(title: "Error", message: error.localizedDescription)
    }
    
    fileprivate func handleResultsReceived(_ cities: [City]) {
        self.results.removeAll()
        self.results.append(contentsOf: cities)
        print("handleResultsReceived = \(self.results)")
        //self.results = cities
        view?.refreshResults()
    }
    

}
