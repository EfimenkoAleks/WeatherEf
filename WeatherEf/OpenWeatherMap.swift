//
//  OpenWeatherMap.swift
//  WeatherEf
//
//  Created by mac on 01.08.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

protocol OpenWeatherMapDelegate {
    
    func updateWeatherInfo(_ weatherJson: JSON)
    func failure()
}

class OpenWeatherMap {
    
    //let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=9235dd62d3f74c7814a8a04526e91cab"
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?"
    let key = "&APPID=9235dd62d3f74c7814a8a04526e91cab"
    
    var delegate: OpenWeatherMapDelegate!
    
    func weatherFor(city: String) {
        
        let params = "q=" + city
        
        let keyWithUrl = weatherUrl + params + key
        
        self.setRequest(keyWithUrl)
        
    }
    
    func weatherFor(geo: CLLocationCoordinate2D) {
        
        // api.openweathermap.org/data/2.5/weather?lat=35&lon=139
       
        let lat = "lat=" + geo.latitude.description
        let lon = "&lon=" + geo.longitude.description
        let geoForRequest = weatherUrl + lat + lon + key
        
        setRequest(geoForRequest)
    }
    
    func setRequest(_ keyWithUrl: String) {
        
        request(keyWithUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.main.async {
                    self.delegate.updateWeatherInfo(json)
                }
            case .failure(let error):
                self.delegate.failure()
                print(error)
            }
        }
    }
    
    func timeForUnix(_ unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        
        return dateFormater.string(from: weatherDate as Date)
    }
    
    func updateWeatherIcon(_ condition: Int, _ nightTime: Bool, _ index: Int, weatherIcon:(_ index: Int, _ icon: String) -> ()) {
     //   var imageName: String
        switch (condition, nightTime) {
            //Thunderstorm
        case let (x,y) where x < 300 && y == true: weatherIcon(index, "11n")
        case let (x,y) where x < 300 && y == false: weatherIcon(index, "11d")
            
            //Drizzle
        case let (x,y) where x < 500 && y == true: weatherIcon(index, "09n")
        case let (x,y) where x < 500 && y == false: weatherIcon(index, "09d")
            
            //Rain
        case let (x,y) where x < 504 && y == true: weatherIcon(index, "10n")
        case let (x,y) where x < 504 && y == false: weatherIcon(index, "10d")
            
        case let (x,y) where x == 511 && y == true: weatherIcon(index, "13n")
        case let (x,y) where x == 511 && y == false: weatherIcon(index, "13d")
            
        case let (x,y) where x < 600 && y == true: weatherIcon(index, "09n")
        case let (x,y) where x < 600 && y == false: weatherIcon(index, "09d")
            
            //Snow
        case let (x,y) where x < 700 && y == true: weatherIcon(index, "13n")
        case let (x,y) where x < 700 && y == false: weatherIcon(index, "13d")
            
            //Atmosfere
        case let (x,y) where x < 800 && y == true: weatherIcon(index, "50n")
        case let (x,y) where x < 800 && y == false: weatherIcon(index, "50d")
            
            //Clouds
        case let (x,y) where x == 800 && y == true: weatherIcon(index, "01n")
        case let (x,y) where x == 800 && y == false: weatherIcon(index, "01d")
            
        case let (x,y) where x == 801 && y == true: weatherIcon(index, "02n")
        case let (x,y) where x == 801 && y == false: weatherIcon(index, "02d")
            
        case let (x,y) where x > 802 || x < 804 && y == true: weatherIcon(index, "03n")
        case let (x,y) where x > 802 || x < 804 && y == false: weatherIcon(index, "03d")
            
        case let (x,y) where x == 804 && y == true: weatherIcon(index, "04n")
        case let (x,y) where x == 804 && y == false: weatherIcon(index, "04d")
            
            //Additional
        case let (x,y) where x < 1000 && y == true: weatherIcon(index, "11n")
        case let (x,y) where x < 1000 && y == false: weatherIcon(index, "11d")
            
        case (_,_): weatherIcon(index, "none")
        }
    }
    
    func convertTemperature(_ country: String, _ temperature: Double) -> Double {
            // Convert to F
        if (country == "US") {
            return round(((temperature - 273.15) * 1.8) + 32)
        } else {
            // Convert to C
            return round(temperature - 273.15)
        }
    }
    
    func isTimeNight(_ icon: String) -> Bool {
        return icon.range(of: "n") != nil
    }
    
}
