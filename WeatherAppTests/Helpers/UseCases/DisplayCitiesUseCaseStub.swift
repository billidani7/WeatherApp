//
//  DisplayCitiesUseCaseStub.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 8/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
@testable import WeatherApp

class DisplayCitiesUseCaseStub: DisplayCitiesUseCase {
    
    var resultToBeReturned: Result<[City]>!
    
    func displayCities(completionHandler: @escaping (Result<[City]>) -> Void) {
        completionHandler(resultToBeReturned)
    }
    

}
