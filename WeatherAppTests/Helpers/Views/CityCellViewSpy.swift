//
//  CityCellView.swift
//  WeatherAppTests
//
//  Created by Vasilis Daningelis on 9/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation
@testable import WeatherApp

class CityCellViewSpy: CityCellView {
    var displayedTitle = ""
    
    func display(title: String) {
        displayedTitle = title
    }
    
    
}
