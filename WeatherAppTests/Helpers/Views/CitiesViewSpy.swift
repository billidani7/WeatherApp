//
//  CitiesViewSpy.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 8/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
@testable import WeatherApp

class CitiesViewSpy: CitiesView {
    var refreshCitiesViewCalled = false
    var displayCitiesRetrievalErrorTitle: String?
    var displayCitiesRetrievalErrorMessage: String?
    var displayCitiesDeleteErrorTitle: String?
    var displayCitiesDeleteErrorMessage: String?
    var deletedRow: Int?
    var endEditingCalled = false
    
    func refreshCitiesView() {
        refreshCitiesViewCalled = true
    }
    
    func displayCitiesRetrievalError(title: String, message: String) {
        displayCitiesRetrievalErrorTitle = title
        displayCitiesRetrievalErrorMessage = message
    }
    
    func displayCitiesDeleteError(title: String, message: String) {
        displayCitiesDeleteErrorTitle = title
        displayCitiesDeleteErrorMessage = message
    }
    
    func deleteAnimated(row: Int) {
        deletedRow = row
    }
    
    func endEditing() {
        endEditingCalled = true
    }
    
    
}
