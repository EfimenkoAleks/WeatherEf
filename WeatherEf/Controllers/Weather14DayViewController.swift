//
//  Weather14DayViewController.swift
//  WeatherEf
//
//  Created by mac on 6/21/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MBProgressHUD

class Weather14DayViewController: UIViewController {
    
    var weather14TableView: UITableView?
    let cellId = "wetherCell"
    var hud = MBProgressHUD()
    var arrayDay = [[ModelForDay14]]()
    var arrayStr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenWeatherMap14.shared.arrayForDay14.removeAll()
        
        self.addTable()
        
        weather14TableView?.register(Weather14Cell.self, forCellReuseIdentifier: cellId)
        
        // Set background
        let bg = UIImage(named: "orig.jpeg")
        self.view.backgroundColor = UIColor(patternImage: bg!)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        self.activityIndicator()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(Weather14DayViewController.backButton(_:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshVC(notification:)), name: NSNotification.Name(rawValue: "refresh14"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.failure(notification:)), name: NSNotification.Name(rawValue: "failur14"), object: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = (UserDefaults.standard.value(forKey: "kSityName") as! String)
        
        
    }
    
    private func addTable() {
        
        weather14TableView = UITableView()
        weather14TableView!.dataSource = self
        weather14TableView!.delegate = self
        weather14TableView!.separatorStyle = .none
        //  weather14TableView?.isScrollEnabled = false
        //  weather14TableView?.isUserInteractionEnabled = false
        weather14TableView!.backgroundColor = UIColor.clear
        weather14TableView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(weather14TableView!)
        
        weather14TableView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 8).isActive = true
        weather14TableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        weather14TableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        weather14TableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    @objc func backButton(_ sender: UIBarButtonItem) {
        AppDelegate.shared.rootViewController.switchToViewController()
    }
    
    func activityIndicator() {
        
        OpenWeatherMap14.shared.weatherForCity()
        
        hud.label.text = "Loading..."
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    @objc func refreshVC(notification: Notification) {
        
        print("Received Notification Weather14")
        
        self.parsForArray()
        self.hud.hide(animated: true)
        
        self.weather14TableView?.reloadData()
    }
    
    func parsForArray() {
        
        let arrayFirst = OpenWeatherMap14.shared.arrayForDay14
        var curentArray = [ModelForDay14]()
        var dayStr = ""
        
        for weatherTime in arrayFirst {
            
            if weatherTime.timeDay == "00:00" && curentArray.count > 0 {
                self.arrayDay.append(curentArray)
                self.arrayStr.append(dayStr)
                curentArray.removeAll()
                curentArray.append(weatherTime)
            } else {
                curentArray.append(weatherTime)
                dayStr = weatherTime.date!
            }
        }
        if curentArray.count > 0 {
            self.arrayDay.append(curentArray)
            self.arrayStr.append(dayStr)
        }
    }
    
    @objc func failure(notification: Notification) {
        //No connection internet
        let networkController = UIAlertController(title: "Error", message: "No connection or wrong city", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        networkController.addAction(okButton)
        self.present(networkController, animated: true, completion: nil)
        
        hud.hide(animated: true)
        
        
        self.weather14TableView?.reloadData()
    }
    
}


extension Weather14DayViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UICollectionViewDataSourse
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        myView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        let hedr: UILabel = {
            let lb = UILabel()
            lb.textAlignment = .left
            lb.font = UIFont.systemFont(ofSize: 24)
            lb.backgroundColor = .clear
            lb.layer.cornerRadius = 8
            lb.layer.masksToBounds = true
            lb.numberOfLines = 1
            lb.textColor = .white
            lb.backgroundColor = .clear
            lb.translatesAutoresizingMaskIntoConstraints = false
            return lb
        }()
        
        myView.addSubview(hedr)
        
        hedr.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 8).isActive = true
        hedr.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true
        hedr.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -8).isActive = true
        //     dayWeek.bottomAnchor.constraint(equalTo: day.bottomAnchor).isActive = true
        hedr.heightAnchor.constraint(equalToConstant: 44).isActive = true
        //    timeDay.widthAnchor.constraint(equalToConstant: self.frame.width / 2).isActive = true
        
        hedr.text = self.arrayStr[section]
        
        return myView
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //   //     self.weather14TableView!.sectionIndexBackgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    //
    //        if self.arrayDay.count > 0 {
    //       return self.arrayStr[section]
    //        } else {
    //            return "nil"
    //        }
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.arrayDay.count > 0 {
            return self.arrayDay.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrayDay[section].count > 0 {
            return self.arrayDay[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! Weather14Cell
        
        if self.arrayDay.count > 0 {
            
            let curentWeather = self.arrayDay[indexPath.section][indexPath.row]
            
            cell.timeDay.text = curentWeather.timeDay
            cell.iconImageView.image = UIImage(named: curentWeather.icon!)
            cell.maxTemp.text = curentWeather.maxTemp
            cell.minTemp.text = curentWeather.minTemp
            cell.selectionStyle = .none
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
}
