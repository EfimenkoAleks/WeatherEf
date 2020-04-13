//
//  CurentWeatherController.swift
//  WeatherEf
//
//  Created by user on 6/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CurentWeatherController: UICollectionViewCell, WeatherCellProtocol {
    
    func cellHeight() -> CGFloat {
        return 300
    }
    
    func cellWidth() -> CGFloat {
        return 300
    }
    
    
    var curentCollection: UICollectionView?
    
    let cellId = "wetherCell"
    let arrayWeather = ["Макс температура, C", "Мин температура, C", "Скорость ветра, м/с", "Влажность, %", "Давление, гПа", "Популяция, чел"]
    var arrayData = ["нет", "нет", "нет", "нет", "нет", "нет"]
    
    let separotorHorizontal: UIView = {
        let sp = UIView()
        sp.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addCollecton()
        
        curentCollection?.register(WeatherCell.self, forCellWithReuseIdentifier: cellId)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshVC(notification:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCollecton() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: self.frame.width, height: 35)
        layout.scrollDirection = .vertical
        
        curentCollection = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        curentCollection!.dataSource = self
        curentCollection!.delegate = self
        curentCollection!.backgroundColor = .clear
        curentCollection?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(curentCollection!)
        
        curentCollection?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        curentCollection?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        curentCollection?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        curentCollection?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
//        self.addSubview(separotorHorizontal)
//        
//        separotorHorizontal.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        separotorHorizontal.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        separotorHorizontal.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        separotorHorizontal.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func refreshVC(notification: Notification) {
        
        print("Received Notification CurentWeatherController")
        self.arrayData.removeAll()
        
        self.arrayData.append(OpenWeatherMap.shared.tempMaxLabelOWM!)
        self.arrayData.append(OpenWeatherMap.shared.tempMinLabelOWM!)
        self.arrayData.append(OpenWeatherMap.shared.speedWindLabelOWM!)
        self.arrayData.append(OpenWeatherMap.shared.humidityLabelOWM!)
        self.arrayData.append(OpenWeatherMap.shared.presureLabelOWM!)
        self.arrayData.append(OpenWeatherMap.shared.populationLabelOWM!)
        
        self.curentCollection?.reloadData()
       
    }
   
}

extension CurentWeatherController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? WeatherCell {
            
            cell.label.text = self.arrayWeather[indexPath.item]
            cell.detailLabel.text = self.arrayData[indexPath.item]
            
            return cell
            
        } else {
            return DayCell()
        }
}

}
