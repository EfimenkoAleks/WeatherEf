//
//  WeatherService.swift
//  WeatherInfoKit
//
//  Created by user on 7/21/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

let _sharedWeatherService: WeatherService = { WeatherService () }()

public class WeatherService: NSObject {
    
  public  typealias WeatherDataCompletionBlok = (_ data: WeatherData?, _ error: NSError?) -> ()
    
    let openWeatherBaseApi = "https://api.openweathermap.org/data/2.5/weather?&q="
    let key = "&APPID=9235dd62d3f74c7814a8a04526e91cab"
    let metric = "&units=metric"
//    let lang = "&lang=ru"
    
    let urlSesion: URLSession = URLSession.shared
    
  public  class func sharedWeatherService() -> WeatherService {
        return _sharedWeatherService
    }
    
  public  func getCurentWeather(location: String, completion: @escaping WeatherDataCompletionBlok) {
        
        let openWeatherApi = openWeatherBaseApi + location + metric + key
//        let request = URLRequest(url: URL(string: openWeatherApi)!)
//
//        let task = urlSesion.dataTask(with: request) { (data, response, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            //Pars JSON data
//            do{
//                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//                let weatherData = WeatherData(weatherDictionary: jsonResult)
//
//                completion(weatherData, nil)
//            } catch {
//                if let jsonError = error as Error? {
//                    print(jsonError.localizedDescription)
//                }
//            }
//
//        }
//        task.resume()
//    }
 
    
    let url = URL(string: openWeatherApi)
    //create the url with NSURL

    //create the session object
    let session = URLSession.shared
    
    //now create the URLRequest object using the url object
    let request = URLRequest(url: url!)
    
    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        
        guard error == nil else {
            return
        }
        
        guard let data = data else {
            return
        }
        
        do {
            //create json object from data
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                
                let weatherData = WeatherData(weatherDictionary: jsonResult as NSDictionary)
                completion(weatherData, nil)
                
                print(jsonResult)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    })
    
    task.resume()
        }
    
    }



//func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
//    // 1
//    dataTask?.cancel()
//    // 2
//    if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
//        urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
//        // 3
//        guard let url = urlComponents.url else { return }
//        // 4
//        dataTask = defaultSession.dataTask(with: url) { data, response, error in
//            defer { self.dataTask = nil }
//            // 5
//            if let error = error {
//                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
//            } else if let data = data,
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 200 {
//                self.updateSearchResults(data)
//                // 6
//                DispatchQueue.main.async {
//                    completion(self.tracks, self.errorMessage)
//                }
//            }
//        }
//        // 7
//        dataTask?.resume()
//    }
//}
