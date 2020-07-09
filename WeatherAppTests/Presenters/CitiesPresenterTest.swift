//
//  CitiesPresenterTest.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 8/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import XCTest
@testable import WeatherApp

class CitiesPresenterTest: XCTestCase {
    // https://www.martinfowler.com/bliki/TestDouble.html
    let diplayCitiesUseCaseStub = DisplayCitiesUseCaseStub()
    let deleteCityUseCaseSpy = DeleteCityUseCaseSpy()
    let citiesViewRouterSpy = CitiesViewRouterSpy()
    let citiesViewSpy = CitiesViewSpy()
    
    var citiesPresenter: CitiesPresenterImplementation!
    
    // MARK: - Set up
    
    override func setUp() {
        super.setUp()
        citiesPresenter = CitiesPresenterImplementation(view: citiesViewSpy, displayCitiesUseCase: diplayCitiesUseCaseStub, deleteCityUseCase: deleteCityUseCaseSpy, delegate: nil, router: citiesViewRouterSpy)
    }
    
    // MARK: - Tests
    
    func test_viewDidLoad_success_refreshCitiesView_called() {
        // Given
        let citiesToBeReturned = City.createCitiesArray()
        diplayCitiesUseCaseStub.resultToBeReturned = .success(citiesToBeReturned)
        
        // When
        citiesPresenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(citiesViewSpy.refreshCitiesViewCalled, "refreshCitiesView was not called")
    }
    
    func test_viewDidLoad_success_numberOfCities() {
        // Given
        let expectedCitiesOfCities = 5
        let citiesToBeReturned = City.createCitiesArray(numberOfElements: expectedCitiesOfCities)
        diplayCitiesUseCaseStub.resultToBeReturned = .success(citiesToBeReturned)
        
        // When
        citiesPresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(expectedCitiesOfCities, citiesPresenter.numberOfCities, "Number of cities mismatch")
    }
    
    func test_viewDidLoad_failure_displayCitiesRetrievalError() {
        // Given
        let expectedErrorTitle = "Error"
        let expectedErrorMessage = "Some error message"
        let errorToBeReturned = NSError.createError(withMessage: expectedErrorMessage)
        diplayCitiesUseCaseStub.resultToBeReturned = .failure(errorToBeReturned)
        
        // When
        citiesPresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(expectedErrorTitle, citiesViewSpy.displayCitiesRetrievalErrorTitle, "Error title doesn't match")
        XCTAssertEqual(expectedErrorMessage, citiesViewSpy.displayCitiesRetrievalErrorMessage, "Error message doesn't match")
    }
    
    func test_configureCell_has_city_name() {
        // Given
        citiesPresenter.cities = City.createCitiesArray()
        let expectedDisplayedTitle = "name 1"
        //let expectedDisplayedAuthor = "Author 1"
        //let expectedDisplayedReleaseDate = "Long time ago"
        
        let cityCellViewSpy = CityCellViewSpy()
        
        // When
        citiesPresenter.configure(cell: cityCellViewSpy, forRow: 1)
        
        // Then
        XCTAssertEqual(expectedDisplayedTitle, cityCellViewSpy.displayedTitle, "The name we expected was not displayed")
    }
    
    func test_canEdit_always_returns_true() {
        // When
        let anyRow = 0
        let canEdit = citiesPresenter.canEdit(row: anyRow)
        
        // Then
        XCTAssertTrue(canEdit, "Can edit should always return true")
    }
    
    func test_titleForDeleteButton_same_for_all_indexes() {
        // Given
        let expectedTitle = "Delete City"
        let anyRow = 0
        
        // When
        let actualTitle = citiesPresenter.titleForDeleteButton(row: anyRow)
        
        // Then
        XCTAssertEqual(expectedTitle, actualTitle, "The title for delete button doesn't match")
    }
    
    func test_deleteButtonPressed_sucess_view_is_updated() {
        // Given
        let rowToDelete = 1
        let cities = City.createCitiesArray()
        let cityToDelete = cities[rowToDelete]
        citiesPresenter.cities = cities
        deleteCityUseCaseSpy.resultToBeReturned = .success(())
        
        // When
        citiesPresenter.deleteButtonPressed(row: rowToDelete)
        
        // Then
        XCTAssertEqual(cityToDelete, deleteCityUseCaseSpy.cityToDelete, "City at wrong index was passed to be deleted")
        XCTAssertEqual(rowToDelete, citiesViewSpy.deletedRow, "Delete on the view should have been called")
        XCTAssertFalse(citiesPresenter.cities.contains(cityToDelete), "City should have been deleted")
    }
    
    func test_deleteButtonPressed_success_city_already_deleted_view_shouldnt_be_updated() {
        // Given
        let rowToDelete = 1
        let cities = City.createCitiesArray()
        citiesPresenter.cities = cities
        deleteCityUseCaseSpy.resultToBeReturned = .success(())
        deleteCityUseCaseSpy.callCompletionHandlerImmediate = false
        
        // When
        citiesPresenter.deleteButtonPressed(row: rowToDelete)
        citiesPresenter.cities.remove(at: rowToDelete)
        deleteCityUseCaseSpy.callCompletionHandler()
        
        // Then
        XCTAssertEqual(cities[rowToDelete], deleteCityUseCaseSpy.cityToDelete, "City at wrong index was passed to be deleted")
        XCTAssertEqual(nil, citiesViewSpy.deletedRow, "Delete on the view shouldn't have been called")
    }
    
    func test_deleteButtonPressed_failure_view_displays_error() {
        // Given
        let rowToDelete = 1
        let cities = City.createCitiesArray()
        citiesPresenter.cities = cities
        let expectedErrorMessage = "Some delete city error message"
        deleteCityUseCaseSpy.resultToBeReturned = .failure(NSError.createError(withMessage: expectedErrorMessage))
        
        // When
        citiesPresenter.deleteButtonPressed(row: rowToDelete)
        
        // Then
        XCTAssertEqual(cities[rowToDelete], deleteCityUseCaseSpy.cityToDelete, "City at wrong index was passed to be deleted")
        XCTAssertEqual("Error", citiesViewSpy.displayCitiesDeleteErrorTitle, "Error title doesn't match")
        XCTAssertEqual(expectedErrorMessage, citiesViewSpy.displayCitiesDeleteErrorMessage, "Error message doesn't match")
    }
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
