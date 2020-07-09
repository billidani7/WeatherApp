//
//  Int+Extension.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 4/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation


extension Int {
    
    func getSmallWeatherImageName(isDayTime: Bool = true) -> String {
        
        var imageName: String = ""
        switch self {
        case 113:
            imageName = isDayTime ? "clear-day" : "clear-night"
        case 176, 293, 296, 299, 302,353, 356, 359, 281, 263, 266:
            imageName = "patchyRain"
        case 116, 119:
            imageName = isDayTime ? "partlyCloudy" : "partlyCloudy-night" 
        case 122:
            imageName = "overcast"
        case 248, 260, 143:
            imageName = "fog"
        case 386, 200:
            imageName = "light-rain-with-thunder"
        case 308, 305, 314:
            imageName = "heavy-rain"
        case 395, 392, 368, 371, 338, 335,
            332, 326, 329, 323, 179,
            227, 230, 185, 377, 350, 284:
            imageName = "snow"
        default:
            imageName = "clear-day"
        }
        
        return imageName
    }
    
    func getWeatherAnimationName(isDayTime: Bool = true) -> String {
        
        var animationName: String = ""
        switch self {
        case 113:
            animationName = isDayTime ? "clear-day" : "clear-night"
        case 176, 293, 296, 299, 302,353, 356, 359, 281, 263, 266:
            animationName = isDayTime ? "patchy-rain" : "patchy-rain-night"
        case 116, 119:
            animationName = isDayTime ? "partlyCloudy" : "partlyCloudy-night"
        case 122:
            animationName = "overcast"
        case 248, 260, 143:
            animationName = "fog"
        case 386, 200:
            animationName = "light-rain-with-thunder"
        case 308, 305, 314:
            animationName = "heavy-rain"
        case 395, 392, 368, 371, 338, 335,
             332, 326, 329, 323, 179,
             227, 230, 185, 377, 350, 284:
            animationName = "snow"
        default:
            animationName = "clear-day"
        }
        
        return animationName
    }
    
}
