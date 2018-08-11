//
//  ViewController.swift
//  WeatherEf
//
//  Created by mac on 31.07.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import CoreLocation

class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var time1Text: String!
    var time2Text: String!
    var time3Text: String!
    var time4Text: String!
    
    var temp1Text: String!
    var temp2Text: String!
    var temp3Text: String!
    var temp4Text: String!
    
    var icon1: UIImageView!
    var icon2: UIImageView!
    var icon3: UIImageView!
    var icon4: UIImageView!
    
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        
        self.displayCity()
        
    }
    
    let locationManager: CLLocationManager = CLLocationManager()
     var openWeather = OpenWeatherMap()
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set background
        let bg = UIImage(named: "background1")
        self.view.backgroundColor = UIColor(patternImage: bg!)
        
        
        // Set setup
        self.openWeather.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func displayCity() {
        
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                self.activityIndicator()
                self.openWeather.weatherFor(city: textField.text!)
            }
        }
        alert.addAction(ok)
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "City name"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    //MARK: OpenWeatherMapDelegate
    func updateWeatherInfo(_ weatherJson: JSON) {
        
        hud.hide(animated: true)
        print(weatherJson)
        
        if let tempResult = weatherJson["list"][0]["main"]["temp"].double {
            
            // get country
            let country = weatherJson["city"]["country"].stringValue
            
            // get city name
            let cityName = weatherJson["city"]["name"].stringValue
            self.cityNameLabel.text = "\(cityName), \(country)"
            
            //Get time
            let now = Int(NSDate().timeIntervalSince1970)
           // let time = weatherJson["list"][0]["dt"].intValue
            let timeToString = openWeather.timeForUnix(now)
            self.timeLabel.text = "At \(timeToString) it is"
            //print(timeToString)
            
            // get convert temperature
            let temperature = openWeather.convertTemperature(country, tempResult)
            self.tempLabel.text = "\(temperature)º"
            //print(temperature)
            
            // get icon
            let weather = weatherJson["list"][0]["weather"][0]
            let condition = weather["id"].intValue
            let iconStr = weather["icon"].stringValue
            let nightTime = openWeather.isTimeNight(iconStr)
            openWeather.updateWeatherIcon(condition, nightTime, 0, weatherIcon: self.updateIconList)
            //self.iconImageView.image = icon
            
            //Get description
            let desc = weather["description"].stringValue
            self.descriptionLabel.text = "\(desc)"
            
            //Get speed wind
            let speed = weatherJson["list"][0]["wind"]["speed"].doubleValue
            self.speedWindLabel.text = "\(speed)"
            
            //Get humidity
            let humidity = weatherJson["list"][0]["main"]["humidity"].intValue
            self.humidityLabel.text = "\(humidity)"
            
            for index in 1...4 {
                
                if let tempResult = weatherJson["list"][index]["main"]["temp"].double
                {
                    //Get convert temperatute
                    let temperature = openWeather.convertTemperature(country, tempResult)
                    
                    if (index == 1) {
                        self.temp1Text = "\(temperature)"
                    } else if (index == 2) {
                        self.temp2Text = "\(temperature)"
                    } else if (index == 3) {
                        self.temp3Text = "\(temperature)"
                    } else if (index == 4) {
                        self.temp4Text = "\(temperature)"
                    }
                    //Get forecast time
                    let forecastTime = weatherJson["list"][index]["dt"].intValue
                    let timeToStr = openWeather.timeForUnix(forecastTime)
                    
                    if (index == 1) {
                        self.time1Text = timeToStr
                    } else if (index == 2) {
                        self.time2Text = timeToStr
                    } else if (index == 3) {
                        self.time3Text = timeToStr
                    } else if (index == 4) {
                        self.time4Text = timeToStr
                    }
                    // get icon
                    let weather = weatherJson["list"][index]["weather"][0]
                    let iconStr = weather["icon"].stringValue
                    let nightTime = openWeather.isTimeNight(iconStr)
                    openWeather.updateWeatherIcon(condition, nightTime, index, weatherIcon: self.updateIconList)
                }
                
            }
        } else {
            print("Unable load weather info")
        }
    }
    
    func updateIconList(index: Int, name: String) {
        if (index == 0) {
            self.iconImageView.image = UIImage(named: name)
        }
        if (index == 1) {
            self.icon1.image = UIImage(named: name)
        }
        if (index == 2) {
            self.icon2.image = UIImage(named: name)
        }
        if (index == 3) {
            self.icon3.image = UIImage(named: name)
        }
        if (index == 4) {
            self.icon4.image = UIImage(named: name)
        }
    }
    
    func failure() {
        //No connection internet
        let networkController = UIAlertController(title: "Error", message: "No connection", preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        networkController.addAction(okButton)
        self.present(networkController, animated: true, completion: nil)
    }
    
    //Mark: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location ?? "Error")
        
        self.activityIndicator()
        let currentLocation = locations.last!
        
        if (currentLocation.horizontalAccuracy > 0 ) {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.openWeather.weatherFor(geo: coords)
            print(coords)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location")
    }
    
    //MARK: PrepareForSegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            let forecastController = segue.destination as! ForecastController
            
            forecastController.time1 = self.time1Text
            forecastController.time2 = self.time2Text
            forecastController.time3 = self.time3Text
            forecastController.time4 = self.time4Text
            
            forecastController.icon1Image.image = self.icon1.image
            forecastController.icon2Image.image = self.icon2.image
            forecastController.icon3Image.image = self.icon3.image
            forecastController.icon4Image.image = self.icon4.image
            
            forecastController.temp1 = self.temp1Text
            forecastController.temp2 = self.temp2Text
            forecastController.temp3 = self.temp3Text
            forecastController.temp4 = self.temp4Text
        }
    }

}

