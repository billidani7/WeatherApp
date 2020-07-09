//
//  NSError.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 9/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


extension NSError {
    static func createError(withMessage message: String) -> NSError {
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
