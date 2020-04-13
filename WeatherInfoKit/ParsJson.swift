//
//  ParsJson.swift
//  WeatherInfoKit
//
//  Created by user on 7/20/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

public class WeatherData: NSObject {
    
  public  let temperature: Double
  public  let icon: String
    
  public  init(weatherDictionary: NSDictionary) {
        
        //Parse JSON data
        let jsonWeather = weatherDictionary["weather"] as! [AnyObject]
        icon = jsonWeather[0]["icon"] as! String
        print(icon)
//        for jsonCurrentWeather in jsonWeather {
//            icon = jsonCurrentWeather["description"] as! String
//        }
        let jsonMain = weatherDictionary["main"] as! [String: AnyObject]
    temperature = jsonMain["temp"] as! Double
    print(temperature)
    }
}

