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

class ViewController: UIViewController, OpenWeatherMapDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBAction func cityTappedButton(_ sender: UIBarButtonItem) {
        
        self.displayCity()
        
    }
    
     var openWeather = OpenWeatherMap()
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        self.openWeather.delegate = self
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
            print(cityName)
            // get convert temperature
            let temperature = openWeather.convertTemperature(country, tempResult)
            print(temperature)
            // get icon
            let weather = weatherJson["weather"][0]
            let condition = weather["id"].intValue
            let nightTime = openWeather.isTimeNight(weatherJson)
            let icon = openWeather.updateWeatherIcon(condition, nightTime)
            self.iconImageView.image = icon
            
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
    

}

