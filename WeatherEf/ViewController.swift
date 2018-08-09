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
        
        if let tempResult = weatherJson["main"]["temp"].double {
            // get country
            let country = weatherJson["sys"]["country"].stringValue
            // get city name
            let cityName = weatherJson["name"].stringValue
            self.cityNameLabel.text = "\(cityName), \(country)"
            //Get time
            let time = weatherJson["dt"].intValue
            let timeToString = openWeather.timeForUnix(time)
            self.timeLabel.text = "At \(timeToString) it is"
            print(timeToString)
            // get convert temperature
            let temperature = openWeather.convertTemperature(country, tempResult)
            self.tempLabel.text = "\(temperature)"
            print(temperature)
            // get icon
            let weather = weatherJson["weather"][0]
            let condition = weather["id"].intValue
            let nightTime = openWeather.isTimeNight(weatherJson)
            let icon = openWeather.updateWeatherIcon(condition, nightTime)
            self.iconImageView.image = icon
            //Get description
            let desc = weather["description"].stringValue
            self.descriptionLabel.text = "\(desc)"
            //Get speed wind
            let speed = weatherJson["wind"]["speed"].doubleValue
            self.speedWindLabel.text = "\(speed)"
            //Get humidity
            let humidity = weatherJson["main"]["humidity"].intValue
            self.humidityLabel.text = "\(humidity)"
            
        } else {
            print("Unable load weather info")
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

}

