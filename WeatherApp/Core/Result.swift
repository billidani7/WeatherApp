//
//  Result.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


struct CoreError: Error {
    var localizedDescription: String {
        return message
    }
    
    var message = ""
}

typealias Result<T> = Swift.Result<T, Error>
