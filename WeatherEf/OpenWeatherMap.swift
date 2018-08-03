//
//  OpenWeatherMap.swift
//  WeatherEf
//
//  Created by mac on 01.08.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import UIKit

class OpenWeatherMap {
    var nameCity: String
    var temp: Double
    var description: String
    var currentTime: String?
    var icon: UIImage?
    
    init(weatherJson: [String: Any]) {
        nameCity = weatherJson["name"] as! String
        let main = weatherJson["main"] as! [String: Any]
        temp = main["temp"] as! Double
        let weather = weatherJson["weather"] as! NSArray
        let zero = weather[0] as! [String: Any]
        description = zero["description"] as! String
        
        let dt = weatherJson["dt"] as! Int
        currentTime = timeForUnix(unixTime: dt)
        
        let strIcon = zero["icon"] as! String
        icon = weatherIcon(stringIcon: strIcon)
    }
    
    func timeForUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        
        return dateFormater.string(from: weatherDate as Date)
    }
    
    func weatherIcon(stringIcon: String) -> UIImage {
        let imageName: String
        
        switch stringIcon {
            case "01d": imageName = "01d"
            case "02d": imageName = "02d"
            case "03d": imageName = "03d"
            case "04d": imageName = "04d"
            case "09d": imageName = "09d"
            case "10d": imageName = "10d"
            case "11d": imageName = "11d"
            case "13d": imageName = "13d"
            case "50d": imageName = "50d"
            case "01n": imageName = "01n"
            case "02n": imageName = "02n"
            case "03n": imageName = "03n"
            case "04n": imageName = "04n"
            case "09n": imageName = "09n"
            case "10n": imageName = "10n"
            case "11n": imageName = "11n"
            case "13n": imageName = "13n"
            case "50n": imageName = "50n"
        default: imageName = "none"
        }
        let iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
}
