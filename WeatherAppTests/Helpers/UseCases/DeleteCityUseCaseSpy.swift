//
//  DeleteCityUseCaseSpy.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 8/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
@testable import WeatherApp

class DeleteCityUseCaseSpy: DeleteCityUseCase {
    var resultToBeReturned: Result<Void>!
    var callCompletionHandlerImmediate = true
    var cityToDelete: City?
    
    private var completionHandler: DeleteCityUseCaseCompletionHandler?
    
    func delete(city: City, completionHandler: @escaping DeleteCityUseCaseCompletionHandler) {
        cityToDelete = city
        self.completionHandler = completionHandler
        
        if callCompletionHandlerImmediate {
            callCompletionHandler()
        }
    }
    
    func callCompletionHandler() {
        self.completionHandler?(resultToBeReturned)
    }
    
}
