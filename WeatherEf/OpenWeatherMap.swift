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
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?"
    let key = "&APPID=9235dd62d3f74c7814a8a04526e91cab"
    
 //   var nameCity: String?
//    var temp: Double?
//    var description: String
//    var currentTime: String?
//    var icon: UIImage?
    
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
    
    func timeForUnix(unixTime: Int) -> String {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        
        return dateFormater.string(from: weatherDate as Date)
    }
    
    func updateWeatherIcon(_ condition: Int, _ nightTime: Bool) -> UIImage {
        var imageName: String
        switch (condition, nightTime) {
            //Thunderstorm
        case let (x,y) where x < 300 && y == true: imageName = "11n"
        case let (x,y) where x < 300 && y == false: imageName = "11d"
            
            //Drizzle
        case let (x,y) where x < 500 && y == true: imageName = "09n"
        case let (x,y) where x < 500 && y == false: imageName = "09d"
            
            //Rain
        case let (x,y) where x < 504 && y == true: imageName = "10n"
        case let (x,y) where x < 504 && y == false: imageName = "10d"
            
        case let (x,y) where x == 511 && y == true: imageName = "13n"
        case let (x,y) where x == 511 && y == false: imageName = "13d"
            
        case let (x,y) where x < 600 && y == true: imageName = "09n"
        case let (x,y) where x < 600 && y == false: imageName = "09d"
            
            //Snow
        case let (x,y) where x < 700 && y == true: imageName = "13n"
        case let (x,y) where x < 700 && y == false: imageName = "13d"
            
            //Atmosfere
        case let (x,y) where x < 800 && y == true: imageName = "50n"
        case let (x,y) where x < 800 && y == false: imageName = "50d"
            
            //Clouds
        case let (x,y) where x == 800 && y == true: imageName = "01n"
        case let (x,y) where x == 800 && y == false: imageName = "01d"
            
        case let (x,y) where x == 801 && y == true: imageName = "02n"
        case let (x,y) where x == 801 && y == false: imageName = "02d"
            
        case let (x,y) where x > 802 || x < 804 && y == true: imageName = "03n"
        case let (x,y) where x > 802 || x < 804 && y == false: imageName = "03d"
            
        case let (x,y) where x == 804 && y == true: imageName = "04n"
        case let (x,y) where x == 804 && y == false: imageName = "04d"
            
            //Additional
        case let (x,y) where x < 1000 && y == true: imageName = "11n"
        case let (x,y) where x < 1000 && y == false: imageName = "11d"
            
        case (_,_): imageName = "none"
        }
        let iconImage = UIImage(named: imageName)
                return iconImage!
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
    
    func isTimeNight(_ wheatherJson: JSON) -> Bool {
        
        var nightTime = false
        let nowTime = NSDate().timeIntervalSince1970
        let sunrise = wheatherJson["sys"]["sunrise"].doubleValue
        let sunset = wheatherJson["sys"]["sunset"].doubleValue
        
        if (nowTime < sunrise || nowTime > sunset) {
            nightTime = true
        }
        return nightTime
    }
    
}
