//
//  CoreDataCitiesGatewayTest.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 9/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import XCTest

@testable import WeatherApp

class CoreDataCitiesGatewayTest: XCTestCase {
    // https://www.martinfowler.com/bliki/TestDouble.html
    var inMemoryCoreDataStack = InMemoryCoreDataStack()
    var managedObjectContextSpy = NSManagedObjectContextSpy()
    
    var inMemoryCoreDataCitiesGateway: CoreDataCitiesGateway {
        return CoreDataCitiesGateway(viewContext: inMemoryCoreDataStack.persistentContainer.viewContext)
    }
    
    var errorPathCoreDataCitiesGateway: CoreDataCitiesGateway {
        return CoreDataCitiesGateway(viewContext: managedObjectContextSpy)
    }
    
    // MARK: - Tests
    
    // Normally add and fetchCities should be tested independently, but in this case since we're not mocking the
    // Core Data piece (we're using an in-memory persistent store) it's fine to test the one via the other
    func test_add_with_parameters_fetchCities_withParameters_success() {
        // Given
        let addCityParameters = AddCityParameters.createParameters()
        
        let addCityCompletionHandlerExpectation = expectation(description: "Add city completion handler expectation")
        let fetchCitiesCompletionHandlerExpectation = expectation(description: "Fetch cities completion handler expectation")
        
        // When
        inMemoryCoreDataCitiesGateway.add(parameters: addCityParameters) { (result) in
            // Then
            guard let city = try? result.get() else {
                XCTFail("Should've saved the city with success")
                return
            }
            
            
            Assert(city: city, builtFromParameters: addCityParameters)
            Assert(city: city, wasAddedIn: self.inMemoryCoreDataCitiesGateway, expectation: fetchCitiesCompletionHandlerExpectation)
            
            addCityCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    
    func test_fetch_failure() {
        // Given
        let expectedResultToBeReturned: Result<[City]> = .failure(CoreError(message: "Failed retrieving cities the data base"))
        managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")
        
        let fetchCitiesCompletionHandlerExpectation = expectation(description: "Fetch cities completion handler expectation")
        
        // When
        errorPathCoreDataCitiesGateway.fetchCities { (result) in
            // Then
            XCTAssertTrue(expectedResultToBeReturned == result, "Failure error wasn't returned")
            fetchCitiesCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_add_with_parameters_fails_without_reaching_save() {
        // Given
        let expectedResultToBeReturned: Result<City> = .failure(CoreError(message: "Failed adding the city in the data base"))
        managedObjectContextSpy.addEntityToReturn = nil
        
        let addCityCompletionHandlerExpectation = expectation(description: "Add city completion handler expectation")
        
        // When
        errorPathCoreDataCitiesGateway.add(parameters: AddCityParameters.createParameters()) { (result) in
            // Then
            XCTAssertTrue(expectedResultToBeReturned == result, "Failure error wasn't returned")
            addCityCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_add_with_parameters_fails_when_saving() {
        // Given
        let expectedResultToBeReturned: Result<City> = .failure(CoreError(message: "Failed saving the context"))
        let addedCoreDataCity = inMemoryCoreDataStack.fakeEntity(withType: CoreDataCity.self)
        managedObjectContextSpy.addEntityToReturn = addedCoreDataCity
        managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")
        
        let addCityCompletionHandlerExpectation = expectation(description: "Add city completion handler expectation")
        
        // When
        errorPathCoreDataCitiesGateway.add(parameters: AddCityParameters.createParameters()) { (result) in
            // Then
            XCTAssertTrue(expectedResultToBeReturned == result, "Failure error wasn't returned")
            XCTAssertTrue(self.managedObjectContextSpy.deletedObject! === addedCoreDataCity, "The inserted entity should've been deleted")
            addCityCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_deleteCity_success() {
        // Given
        let addCityParameters1 = AddCityParameters.createParameters()
        var addedCity1: City!
        let addCity1CompletionHandlerExpectation = expectation(description: "Add city completion handler expectation")
        inMemoryCoreDataCitiesGateway.add(parameters: addCityParameters1) { (result) in
            addedCity1 = try! result.get()
            addCity1CompletionHandlerExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        let addCityParameters2 = AddCityParameters.createParameters()
        var addedCity2: City!
        let addCity2CompletionHandlerExpectation = expectation(description: "Add city completion handler expectation")
        
        inMemoryCoreDataCitiesGateway.add(parameters: addCityParameters2) { (result) in
            addedCity2 = try! result.get()
            addCity2CompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        let deleteCityCompletionHandlerExpectation = expectation(description: "Delete city completion handler expectation")
        
        // When
        inMemoryCoreDataCitiesGateway.delete(city: addedCity1) { (result) in
            XCTAssertTrue(result == Result<Void>.success(()), "Expected a success result")
            deleteCityCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let fetchCitiesCompletionHandlerExpectation = expectation(description: "Fetch cities completion handler expectation")
        inMemoryCoreDataCitiesGateway.fetchCities { (result) in
            let cities = try! result.get()
            XCTAssertFalse(cities.contains(addedCity1), "The added city should've been deleted")
            XCTAssertTrue(cities.contains(addedCity2), "The second city should be contained")
            fetchCitiesCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_delete_save_fails() {
        // City
        let cityToDelete = City.createCity()
        let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed saving the context"))
        managedObjectContextSpy.entitiesToReturn = [inMemoryCoreDataStack.fakeEntity(withType: CoreDataCity.self)]
        managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")
        
        let deleteCityCompletionHandlerExpectation = expectation(description: "Delete city completion handler expectation")
        
        // When
        errorPathCoreDataCitiesGateway.delete(city: cityToDelete) { (result) in
            // Then
            XCTAssertTrue(expectedResultToBeReturned == result, "Failure error wasn't returned")
            deleteCityCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
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


// MARK: - Helpers

// https://www.bignerdranch.com/blog/creating-a-custom-xctest-assertion/
fileprivate func Assert(city: City, builtFromParameters parameters: AddCityParameters, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(city.name, parameters.name, "name mismatch", file: file, line: line)
    XCTAssertEqual(city.country, parameters.country, "country mismatch", file: file, line: line)
    XCTAssertEqual(city.latitude, parameters.latitude, "latitude mismatch", file: file, line: line)
    XCTAssertEqual(city.longitude, parameters.longitude, "longitude mismatch", file: file, line: line)
    XCTAssertTrue(city.id != "", "id should not be empty", file: file, line: line)
}

fileprivate func Assert(city: City, wasAddedIn coreDataCitiesGateway: CoreDataCitiesGateway, expectation: XCTestExpectation) {
    coreDataCitiesGateway.fetchCities { (result) in
        guard let cities = try? result.get() else {
            XCTFail("Should've fetched the cities with success")
            return
        }
        
        XCTAssertTrue(cities.contains(city), "City is not found in the returned cities")
        XCTAssertEqual(cities.count, 1, "Cities array should contain exactly one city")
        expectation.fulfill()
    }
}
