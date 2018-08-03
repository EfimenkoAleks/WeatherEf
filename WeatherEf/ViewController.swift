//
//  ViewController.swift
//  WeatherEf
//
//  Created by mac on 31.07.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    let url = "https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=9235dd62d3f74c7814a8a04526e91cab"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
 //       var nameCity : String!
        
        request(url).responseJSON { (response) in
         //   print(response)
            
           if let weatherJSON = response.result.value as? [String: Any] {
            
            let weather = OpenWeatherMap(weatherJson: weatherJSON)
            print(weather.nameCity)
            print(weather.temp)
            print(weather.description)
            print(weather.currentTime!)
            print(weather.icon!)
            
            self.iconImageView.image = weather.icon!
            
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

