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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var mainCollection: UICollectionView?
    var conteyner: UIContentContainer?
    
    var arrayCell = [WeatherCellProtocol]()
    let arrayStrIdentiferCell = ["DayCell", "CurentCell"]
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var hud = MBProgressHUD()
    
    var selected = false
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "none")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    var cityNameLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 25)
        lb.backgroundColor = .clear
        lb.shadowColor = .black
        let size = CGSize(width: 0, height: -1)
        lb.shadowOffset = size
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 25)
        lb.backgroundColor = .clear
        lb.shadowColor = .black
        let size = CGSize(width: 0, height: -1)
        lb.shadowOffset = size
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var tempLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 50)
        lb.backgroundColor = .clear
        lb.shadowColor = .black
        let size = CGSize(width: 0, height: -1)
        lb.shadowOffset = size
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let day = DayWeatherController()
        let curent = CurentWeatherController()
        self.arrayCell.append(day)
        self.arrayCell.append(curent)
        
        self.addCollecton()
        
        mainCollection?.register(DayWeatherController.self, forCellWithReuseIdentifier: self.arrayStrIdentiferCell[0])
        mainCollection?.register(CurentWeatherController.self, forCellWithReuseIdentifier: self.arrayStrIdentiferCell[1])
        
        // Set background
        let bg = UIImage(named: "orig.jpeg")
        self.view.backgroundColor = UIColor(patternImage: bg!)
        
        //     self.view.backgroundColor = .white
        
        // Set setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.startLocation()
        
        //        var preferredStatusBarStyle: UIStatusBarStyle {
        //            return .lightContent
        //
        //        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        //       navigationController?.navigationBar.tintColor = .black
        //       navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "City", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.addCity(_:)))
        
        self.setRightButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshVC(notification:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        
        //        var appGroupDefaults = UserDefaults.standard
        //        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
        //        appGroupDefaults.set(nil, forKey: "cityForWidget")
    }
    
    private func setRightButton() {
        
        let button1 = UIBarButtonItem(title: "5 day", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.showDetail(_:)))
        
        let button2 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.startLocation))
        
        navigationItem.rightBarButtonItems = [button1, button2]
        
    }
    
    private func addCollecton() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 100)
        layout.scrollDirection = .vertical
        
        mainCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        mainCollection!.dataSource = self
        mainCollection!.delegate = self
        mainCollection?.isScrollEnabled = false
        mainCollection!.backgroundColor = .clear
        mainCollection?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainCollection!)
        
        mainCollection?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (self.view.frame.height / 2) - (self.view.frame.height / 10)).isActive = true
        mainCollection?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainCollection?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainCollection?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        view.addSubview(cityNameLabel)
        view.addSubview(iconImageView)
        view.addSubview(tempLabel)
        view.addSubview(descriptionLabel)
        
        cityNameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 7).isActive = true
        cityNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cityNameLabel.bottomAnchor.constraint(equalTo: self.tempLabel.topAnchor).isActive = true
        
        iconImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.cityNameLabel.bottomAnchor, constant: 10).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: self.tempLabel.leadingAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        tempLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor).isActive = true
        tempLabel.topAnchor.constraint(equalTo: self.cityNameLabel.bottomAnchor, constant: 10).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor).isActive = true
        tempLabel.heightAnchor.constraint(equalTo: self.iconImageView.heightAnchor).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.tempLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        
        
    }
    
    @objc func startLocation() {
        
        locationManager.startUpdatingLocation()
        
    }
    
    @objc func showDetail(_ sender: UIBarButtonItem) {
        
        AppDelegate.shared.rootViewController.showDetailScreen()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshVC(notification: Notification) {
        
        print("Received Notification")
        self.weatherInfo()
        
    }
    
    
    @objc func addCity(_ sender: UIButton) {
        self.displayCity()
    }
    
    func displayCity() {
        
        let alert = UIAlertController(title: "City", message: "Enter name city", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) {
            (action) -> Void in
            if let textField = alert.textFields?.first {
                self.activityIndicator()
                OpenWeatherMap.shared.weatherFor(city: textField.text!)
                //            DispatchQueue.global(qos: .utility).async {
                //                OpenWeatherMap14.shared.weatherForCity8Hours()
                //             }
                
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.failure(notification:)), name: NSNotification.Name(rawValue: "failur"), object: nil)
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
    
    func weatherInfo() {
        
        hud.hide(animated: true)
        
        self.cityNameLabel.text = OpenWeatherMap.shared.cityNameLabelOWM
        
        self.tempLabel.text = OpenWeatherMap.shared.tempLabelOWM
        
        self.iconImageView.image = UIImage(named: OpenWeatherMap.shared.iconImageViewOWM!)
        
        self.descriptionLabel.text = OpenWeatherMap.shared.descriptionLabelOWM
        
        
        var appGroupDefaults = UserDefaults.standard
        appGroupDefaults = UserDefaults(suiteName:"group.com.Efimenko.WeatherEf")!
        
        appGroupDefaults.set(OpenWeatherMap.shared.tempLabelOWM, forKey: "temperatuteForWidget")
        appGroupDefaults.set(OpenWeatherMap.shared.iconImageViewOWM, forKey: "imageForWidget")
        appGroupDefaults.set(OpenWeatherMap.shared.cityNameLabelOWM, forKey: "cityForWidget")
    }
    
    @objc func failure(notification: Notification) {
        //No connection internet
        let networkController = UIAlertController(title: "Error", message: "No connection or wrong city", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        networkController.addAction(okButton)
        self.present(networkController, animated: true, completion: nil)
        
        hud.hide(animated: true)
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
            
            OpenWeatherMap.shared.weatherFor(geo: coords)
            //            print(coords)
            OpenWeatherMap14.shared.weatherForGeo8Hours()
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cantGetLocation = true
        print("Can't get your location")
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.arrayStrIdentiferCell[indexPath.item], for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = self.view.frame.width - 20
        let height: CGFloat = self.arrayCell[indexPath.item].cellHeight()
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
}





