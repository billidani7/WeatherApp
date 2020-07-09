//
//  Weather.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

struct Weather {
    var currentCondition: WeatherCondition
    var fiveDayForecast: [DayWeather]
    
    
}

struct WeatherCondition {
    var utcDate: String
    var utcTime: String
    
    var isDayTime: Bool
    
    var dateObject: Date
    var localDateTimeString: String
    
    var tempF: String
    var tempC: String
    
    var weatherCode: Int
    var weatherDesc: String
    
    
    init(utcDate: String, utcTime: String, isDayTime: String, tempF: String, tempC: String, weatherCode: Int, weatherDesc: String) {
        self.utcDate = utcDate
        self.utcTime = utcTime
        self.isDayTime = isDayTime == "yes" ? true : false
        self.tempF = tempF
        self.tempC = tempC
        self.weatherCode = weatherCode
        self.weatherDesc = weatherDesc
        if utcTime == "0" {
            self.utcTime = "000"
        }
        self.localDateTimeString = WeatherCondition.utcDateTimeToLocal(utcDate: utcDate, utcTime: self.utcTime)
        
        self.dateObject = WeatherCondition.getUtcDateTime(utcDate: utcDate, utcTime: self.utcTime)
        
        
    }
    
    static func getUtcDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"  //Input Format in utc
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let utcDate = dateFormatter.string(from: Date())
        
        return utcDate
    }
    
    static func getUtcDateTime(utcDate: String, utcTime: String) -> Date {
        
        let dateFormatter = DateFormatter()
        // API returns two formats. hmm (200) and hhmm (2100)
        dateFormatter.dateFormat =  utcTime.count > 3 ? "yyyy-MM-dd HHmm" : "yyyy-MM-dd hmm" //Input Format in utc
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let utcDate = dateFormatter.date(from: "\(utcDate) \(utcTime)")
        
        return utcDate!
        
        
    }
    
    static func utcDateTimeToLocal(utcDate: String, utcTime: String) -> String {
        let dateFormatter = DateFormatter()
        // API returns two formats. hmm (200) and hhmm (2100)
        dateFormatter.dateFormat =  utcTime.count > 3 ? "yyyy-MM-dd HHmm" : "yyyy-MM-dd hmm" //Input Format in utc
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //print("\(utcDate) \(utcTime)")
        let UTCDate = dateFormatter.date(from: "\(utcDate) \(utcTime)")
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm a"   // Output Format in local time
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }

        
    static let outputTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.timeStyle = .short
        //formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

struct DayWeather {
    var date: Date?
    var dateString: String
    var maxtempC: String
    var mintempC: String
    //var weatherCode: Int
    //var weatherDesc: String
    var hourlyCondition: [WeatherCondition]
    
    init(dateString: String, maxtempC: String, mintempC: String, hourlyCondition: [WeatherCondition]) {
        self.date = DayWeather.formatter.date(from: dateString)
        self.dateString = dateString
        self.maxtempC = maxtempC
        self.mintempC = mintempC
        //self.weatherCode = weatherCode
        //self.weatherDesc = weatherDesc
        self.hourlyCondition = hourlyCondition
    }
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    static let outputDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        //formatter.dateStyle = .short
        return formatter
    }()
    
    
    static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    
}

//struct CurrentWeather {
//    //let maxtempC, maxtempF, mintempC, mintempF, tempC, tempF, weatherDesc
//    let tempC: String
//    let weatherDesc: String?
//}
//
//struct HourlyWeather {
//    let time: String
//    let tempC: String
//    let weatherDesc: String?
//}
