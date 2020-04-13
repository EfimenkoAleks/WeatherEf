//
//  OpenWeatherMap14.swift
//  WeatherEf
//
//  Created by mac on 6/20/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class OpenWeatherMap14 {
    
    static let shared = OpenWeatherMap14()
    
    //let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=9235dd62d3f74c7814a8a04526e91cab"
    // api.openweathermap.org/data/2.5/forecast?lat=35&lon=139
    // api.openweathermap.org/data/2.5/forecast?q=London,us
    
    // api.openweathermap.org/data/2.5/forecast?q={city name}&appid={your api key}
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?"
    let key = "&appid=9235dd62d3f74c7814a8a04526e91cab"
    
    
    
    var arrayForDay14 = [ModelForDay14]()
    
    func setRequest(_ keyWithUrl: String) {
        
        request(keyWithUrl, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                DispatchQueue.main.async {
                    self.updateWeatherInfo(json)
                }
            case .failure(let error):
                //                    self.isFailure = true
                print(error)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "failur14"), object: nil)
            }
        }
        //        }
    }
    
    func updateWeatherInfo(_ weatherJson: JSON) {
        
        self.arrayForDay14.removeAll()
     //   print("weatherJson \(weatherJson.count)")
//        guard let listArray = weatherJson else { return }
       
        for day in 0 ..< 40 {
            
            if (weatherJson["list"][day]["main"]["temp_max"].double != nil) {
                
                guard let tempMax = weatherJson["list"][day]["main"]["temp_max"].double,
                    let tempMin = weatherJson["list"][day]["main"]["temp_min"].double,
                    let date = weatherJson["list"][day]["dt_txt"].string,
                    let cityName = weatherJson["city"]["name"].string,
                    let icon = weatherJson["list"][day]["weather"][0]["icon"].string else {return}
                
                print("\(tempMax)")
                
                let curentTime = ModelForDay14()
                
                // get country
                let country = weatherJson["city"]["country"].stringValue
                
                // get convert temperature
                let temperatureMax = self.convertTemperature(country, tempMax)
                
                let temperatureMin = self.convertTemperature(country, tempMin)
                
                //date
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                //  dateFormatter.locale = Locale.init(identifier: "en_GB")
                
                let dateObj = dateFormatter.date(from: date)
                dateFormatter.dateFormat = "EEEE, MMM d"
                let dateString = dateFormatter.string(from: dateObj!)
                dateFormatter.dateFormat = "HH:mm"
                let timeDay = dateFormatter.string(from: dateObj!)
                
                dateFormatter.dateFormat = "dd"
                let daySep = dateFormatter.string(from: dateObj!)
                
                curentTime.timeDay = timeDay
                curentTime.maxTemp = "\(temperatureMax)º"
                curentTime.minTemp = "\(temperatureMin)º"
                curentTime.city = "\(cityName), \(country)"
                curentTime.icon = icon
                curentTime.dayForSep = daySep
                curentTime.date = dateString
                
                
                
                self.arrayForDay14.append(curentTime)
            }
        }
        
        print("End pars weather14")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh14"), object: nil)
        
    }
    
    
    
    func weatherForCity() {
        // api.openweathermap.org/data/2.5/forecast?q=London,us   &mode=xml
        
        let city = "q=" + (UserDefaults.standard.value(forKey: "kSityName") as! String)
//        let lang = "&lang=ru"
        //    let units = "&units=metric"
        
        let keyWithUrl = weatherUrl + city + key
        
        self.setRequest(keyWithUrl)
        print("\(keyWithUrl)")
    }
    
    func weatherForCity8Hours() {
        // api.openweathermap.org/data/2.5/forecast?q=London,us   &mode=xml
        
        let city = (UserDefaults.standard.value(forKey: "kSityWeather") as! String)
        //    print(city)
        let cnt = "&cnt=8"
//        let lang = "&lang=ru"
        //    let units = "&units=metric"
        
        let keyWithUrl = weatherUrl + city + cnt + key
        
        self.setRequest(keyWithUrl)
        
    }
    
    func weatherForGeo() {
        
        let lat = (UserDefaults.standard.value(forKey: "kLat") as! String)
        let lon = (UserDefaults.standard.value(forKey: "kLon") as! String)
//        let lang = "&lang=ru"
        let geoForRequest = weatherUrl + lat + lon + key
        
        setRequest(geoForRequest)
        
        //  api.openweathermap.org/data/2.5/forecast/daily? lat=35 &lon=139 &cnt=10
    }
    
    func weatherForGeo8Hours() {
        
        let lat = (UserDefaults.standard.value(forKey: "kLat") as! String)
        let lon = (UserDefaults.standard.value(forKey: "kLon") as! String)
//        let lang = "&lang=ru"
        let cnt = "&cnt=8"
        let geoForRequest = weatherUrl + lat + lon + cnt + key
        
        setRequest(geoForRequest)
        
        //  api.openweathermap.org/data/2.5/forecast/daily? lat=35 &lon=139 &cnt=10
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
    
}

extension Date {
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
}


