//
//  Model.swift
//  WeatherEf
//
//  Created by user on 5/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
//
var cantGetLocation: Bool?
var temperatureIcon: Int?
var curentKeyWithUrl: String?
var curentKeyWithUrl14: String?

//func requestForNotification() {
//    UNUserNotificationCenter.current().requestAuthorization(options: [.badge
//    ]) { (isEnabled, error) in
//        if isEnabled {
//            print("Yes")
//        } else {
//            return
//        }
//    }
//}

//func setBasge() {
//    
//    if let temper = temperatureIcon {
//    UIApplication.shared.applicationIconBadgeNumber = temper
//    }
//    print("setBasge")
//}

//    func delay(_ delay: Double, closure: @escaping ()->()) {
//        let when = DispatchTime.now() + delay
//        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
//    }
