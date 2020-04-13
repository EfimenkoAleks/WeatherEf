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

class OpenWeatherMap {
    
    static let shared = OpenWeatherMap()
    
    //let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=9235dd62d3f74c7814a8a04526e91cab"
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?"
    let key = "&APPID=9235dd62d3f74c7814a8a04526e91cab"
    
    //  api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10
    
    var iconImageViewOWM: String?
    var cityNameLabelOWM: String?
    var timeLabelOWM: String?
    var tempLabelOWM: String?
    var tempMinLabelOWM: String?
    var tempMaxLabelOWM: String?
    var speedWindLabelOWM: String?
    var humidityLabelOWM: String?
    var descriptionLabelOWM: String?
    var presureLabelOWM: String?
    var populationLabelOWM: String?
    
    var isFailure: Bool = false
    
    func setRequest(_ keyWithUrl: String) {
        
        curentKeyWithUrl = keyWithUrl
        if let curentKey = curentKeyWithUrl {
            request(curentKey, method: .get).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    DispatchQueue.main.async {
                        self.updateWeatherInfo(json)
                    }
                case .failure(let error):
                    self.isFailure = true
                    print(error)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "failur"), object: nil)
                }
            }
        }
    }
    
    // for background work
    func setRequestForBackground() -> Int {
        
        var vol = 0
        
        if let curentKey = curentKeyWithUrl {
            request(curentKey, method: .get).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    if let tempResult = json["list"][0]["main"]["temp"].double {
                        let country = json["city"]["country"].stringValue
                        let temperature = self.convertTemperature(country, tempResult)
                        temperatureIcon = Int(temperature)
                        
                        // get city name
                        let cityName = json["city"]["name"].stringValue
                        self.cityNameLabelOWM = "\(cityName), \(country)"
                        
                        let weather = json["list"][0]["weather"][0]
                        let condition = weather["id"].intValue
                        let iconStr = weather["icon"].stringValue
                        let nightTime = self.isTimeNight(iconStr)
                        self.updateWeatherIcon(condition, nightTime, 0, weatherIcon: self.updateIconList(index:name:))
                        
                        var appGroupDefaults = UserDefaults.standard
                        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
                        
                        //  appGroupDefaults.set(self.tempLabelOWM, forKey: "temperatuteForWidget")
                        //   appGroupDefaults.set(self.iconImageViewOWM, forKey: "imageForWidget")
                        appGroupDefaults.set(self.cityNameLabelOWM, forKey: "cityForWidget")
                        
                        vol = 1
                        
                    }
                case .failure(let error):
                    print(error)
                    vol = 2
                }
            }
        }
        print("setRequestForBackground")
        return vol
    }
    
    func updateWeatherInfo(_ weatherJson: JSON) {
        
        //     print(weatherJson)
        
        if let tempResult = weatherJson["list"][0]["main"]["temp"].double {
            
            //max and min temperature
            let maxTemp = weatherJson["list"][0]["main"]["temp_max"].double
            let minTemp = weatherJson["list"][0]["main"]["temp_min"].double
            
            //presure
            if let presure = weatherJson["list"][0]["main"]["pressure"].int {
                self.presureLabelOWM = presure.description
            } else {
                self.presureLabelOWM = "нет"
            }
            
            //date
            //           let date = weatherJson["list"][0]["dt_txt"].stringValue
            
            //population
            if let population = weatherJson["city"]["population"].int {
                self.populationLabelOWM = population.description
            } else {
                self.populationLabelOWM = "нет"
            }
            
            // get country
            let country = weatherJson["city"]["country"].stringValue
            
            // get city name
            let cityName = weatherJson["city"]["name"].stringValue
            self.cityNameLabelOWM = "\(cityName),\(country)"
            UserDefaults.standard.set(self.cityNameLabelOWM, forKey: "kSityName")
            
            var appGroupDefaults = UserDefaults.standard
            appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
            appGroupDefaults.set(self.cityNameLabelOWM, forKey: "kCityForWidget")
            
            //Get time
            let now = Int(NSDate().timeIntervalSince1970)
            // let time = weatherJson["list"][0]["dt"].intValue
            let timeToString = self.timeForUnix(now)
            self.timeLabelOWM = "At \(timeToString) it is"
            //print(timeToString)
            
            // get convert temperature
            let temperature = self.convertTemperature(country, tempResult)
            self.tempLabelOWM = "\(temperature)º"
            
            if let tempAnrap = maxTemp {
                let maxTempRez = self.convertTemperature(country, tempAnrap)
                self.tempMaxLabelOWM = "\(maxTempRez)º"
            } else {
                self.tempMaxLabelOWM = "нет"
            }
            if let tempAnrap = minTemp {
                let minTempRez = self.convertTemperature(country, tempAnrap)
                self.tempMinLabelOWM = "\(minTempRez)º"
            } else {
                self.tempMinLabelOWM = "нет"
            }
            
            temperatureIcon = Int(temperature)
            if let temp = temperatureIcon?.description {
                print(temp)
            }
            
            
            // get icon
            let weather = weatherJson["list"][0]["weather"][0]
            let condition = weather["id"].intValue
            let iconStr = weather["icon"].stringValue
            let nightTime = self.isTimeNight(iconStr)
            self.updateWeatherIcon(condition, nightTime, 0, weatherIcon: self.updateIconList(index:name:))
            //self.iconImageView.image = icon
            
            //Get description
            let desc = weather["description"].stringValue
            self.descriptionLabelOWM = "\(desc)"
            
            //Get speed wind
            if let speed = weatherJson["list"][0]["wind"]["speed"].int {
                self.speedWindLabelOWM = speed.description
            } else {
                self.speedWindLabelOWM = "нет"
            }
            
            //Get humidity
            if let humidity = weatherJson["list"][0]["main"]["humidity"].int {
                self.humidityLabelOWM = humidity.description
            } else {
                self.humidityLabelOWM = "нет"
            }
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
    }
    
    
    func updateIconList(index: Int, name: String) {
        if (index == 0) {
            self.iconImageViewOWM = name
        }
        
    }
    
    func weatherFor(city: String) {
        
        let params = "q=" + city //+ ",ua"
//        let lang = "&lang=ru"
        
        let keyWithUrl = weatherUrl + params + key
        
        self.setRequest(keyWithUrl)
        
        //       print("OpenWether \(keyWithUrl)")
        
        UserDefaults.standard.set(params, forKey: "kSityWeather")
        UserDefaults.standard.synchronize()
        
        OpenWeatherMap14.shared.weatherForCity8Hours()
    }
    
    func weatherFor(geo: CLLocationCoordinate2D) {
        
        // api.openweathermap.org/data/2.5/weather?lat=35&lon=139
        
        let lat = "lat=" + geo.latitude.description
        let lon = "&lon=" + geo.longitude.description
 //       let lang = "&lang=ru"
        let geoForRequest = weatherUrl + lat + lon + key
        
        //  для апделегата для бекграунд извлечения
        UserDefaults.standard.set(geoForRequest, forKey: "kForAppDelegate")
        
        setRequest(geoForRequest)
        
        UserDefaults.standard.set(lat, forKey: "kLat")
        UserDefaults.standard.set(lon, forKey: "kLon")
        UserDefaults.standard.synchronize()
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
