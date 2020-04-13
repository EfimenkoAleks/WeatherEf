//
//  TodayViewController.swift
//  WeatherEfWidget
//
//  Created by user on 6/16/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherInfoKit


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var celsLabel: UILabel!
    @IBOutlet weak var widgetImage: UIImageView!
    
    var location = "Odessa,ua"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //         Do any additional setup after loading the view.
        
        //   self.preferredContentSize = CGSize(width: 320, height: CGFloat(yourArrayValuesCount.count)*90 )
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
        
 //       self.nameLabel.text = location
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        var appGroupDefaults = UserDefaults.standard
//        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
//        if let locationCity = appGroupDefaults.value(forKey: "cityForWidget") as? String {
//            location = locationCity
//        }
//        self.nameLabel.text = location
//
//        WeatherService.sharedWeatherService().getCurentWeather(location: location) { (data, error) in
//
//            if error == nil {
//                DispatchQueue.main.async {
//                    if let weatherData = data {
//                        let temp = Int(weatherData.temperature)
//                        self.widgetImage.image = UIImage(named: weatherData.icon)
//                        self.celsLabel.text = temp.description + "º"
//                    }
//                }
//            }
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var appGroupDefaults = UserDefaults.standard
        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
        if let locationCity = appGroupDefaults.value(forKey: "kCityForWidget") as? String {
            location = locationCity
        }
        self.nameLabel.text = location
        
        WeatherService.sharedWeatherService().getCurentWeather(location: location) { (data, error) in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let weatherData = data {
                        let temp = Int(weatherData.temperature)
                        self.widgetImage.image = UIImage(named: weatherData.icon)
                        self.celsLabel.text = temp.description + "º"
                    }
                }
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        var appGroupDefaults = UserDefaults.standard
        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
        if let locationCity = appGroupDefaults.value(forKey: "kCityForWidget") as? String {
            location = locationCity
        }
        self.nameLabel.text = location
        
        WeatherService.sharedWeatherService().getCurentWeather(location: location) { (data, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let weatherData = data {
                        let temp = Int(weatherData.temperature)
                        self.widgetImage.image = UIImage(named: weatherData.icon)
                        self.celsLabel.text = temp.description + "º"
                    }
                }
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        }
        
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: 320, height: 30) : CGSize(width: maxSize.width, height: 30)
    }
    
    
}
