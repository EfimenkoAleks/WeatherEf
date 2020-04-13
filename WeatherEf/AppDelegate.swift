//
//  AppDelegate.swift
//  WeatherEf
//
//  Created by mac on 31.07.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //    var second: Int?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        let viewController = ViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
        //        let navigationController = UINavigationController(rootViewController: viewController)
        //
        //
        
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //        self.window?.rootViewController = navigationController
        //        self.window?.makeKeyAndVisible()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        // Fetch no sooner than every (60) seconds which is thrillingly short actually.
        // Defaults to Infinite if not set.
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //
    //        var fetchResult: UIBackgroundFetchResult!
    //
    //        switch OpenWeatherMap.shared.setRequestForBackground() {
    //        case 1:
    //            fetchResult = .newData
    //            break
    //        case 2:
    //            fetchResult = .failed
    //            break
    //        default:
    //            fetchResult = .noData
    //        }
    
    //
    //        completionHandler(fetchResult)
    //    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        
        //api.openweathermap.org/data/2.5/weather?q=London,uk
        //      let city = "q=Berdiansk,ua"
        
        //       let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?"
        //      let key = "&APPID=9235dd62d3f74c7814a8a04526e91cab"
        //               let lat = (UserDefaults.standard.value(forKey: "kLat") as! String)
        //             let lon = (UserDefaults.standard.value(forKey: "kLon") as! String)
        //           let curentKey = weatherUrl + lat + lon + key
        let curentKey: String?
        
        if UserDefaults.standard.value(forKey: "kForAppDelegate") as? String != nil {
            curentKey = (UserDefaults.standard.value(forKey: "kForAppDelegate") as! String)
            
            request(curentKey!, method: .get).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    if let tempResult = json["main"]["temp"].double {
                        let temp = round(tempResult - 273.15)
                        let temperature = "\(temp)º"
                        let country = json["sys"]["country"].stringValue
                        let cityName = json["name"].stringValue
                        let city = "\(cityName),\(country)"
                        //                  let icon = json["weather"][0]["icon"].stringValue
                        
                        var appGroupDefaults = UserDefaults.standard
                        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
                        //                   appGroupDefaults.set(temperature, forKey: "temperatuteForWidget")
                        //                    appGroupDefaults.set(icon, forKey: "imageForWidget")
                        appGroupDefaults.set(city, forKey: "kCityForWidget")
                        print("\(cityName)")
                        print("\(temperature)")
                        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppDelegateBackgroundRefresh"), object: nil)
                    }
                    print("fetch new data")
                    completionHandler(.newData)
                    
                case .failure(let error):
                    print(error)
                    completionHandler(.failed)
                }
            }
        }
    }
    
    
    
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}

