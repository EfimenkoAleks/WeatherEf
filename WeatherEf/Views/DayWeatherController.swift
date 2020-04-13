//
//  DayWeatherController.swift
//  WeatherEf
//
//  Created by user on 6/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DayWeatherController: UICollectionViewCell, WeatherCellProtocol {
    
    func cellHeight() -> CGFloat {
        return 100
    }
    
    func cellWidth() -> CGFloat {
        return 300
    }
    
    
    var dayCollection: UICollectionView?
    let cellId = "wetherCell"
    var arrayDay = [ModelForDay14]()
    
    let separotorHorizontal: UIView = {
        let sp = UIView()
        sp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sp.translatesAutoresizingMaskIntoConstraints = false
        return sp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        self.addCollecton()
        dayCollection?.register(DayCell.self, forCellWithReuseIdentifier: cellId)        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshVC(notification:)), name: NSNotification.Name(rawValue: "refresh14"), object: nil)
        
   //     NotificationCenter.default.addObserver(self, selector: #selector(self.refreshVC(notification:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addCollecton() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 50, height: 100)
        layout.scrollDirection = .horizontal
        
        dayCollection = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        dayCollection!.dataSource = self
        dayCollection!.delegate = self
        dayCollection!.backgroundColor = .clear
         dayCollection?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dayCollection!)
        
        dayCollection?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dayCollection?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dayCollection?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
         dayCollection?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(separotorHorizontal)
        
        separotorHorizontal.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separotorHorizontal.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separotorHorizontal.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        separotorHorizontal.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func refreshVC(notification: Notification) {
        
        print("Received Notification DayWeatherController")
        self.arrayDay.removeAll()
        
        let arrayFirst = OpenWeatherMap14.shared.arrayForDay14
 
        for weatherTime in arrayFirst {
 
         self.arrayDay.append(weatherTime)
            
        }
        
        self.dayCollection?.reloadData()
        
    }
    
}

extension DayWeatherController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? DayCell {
                   
      let day = self.arrayDay[indexPath.item]
            
            cell.labelTime.text = day.timeDay
            cell.imageView.image = UIImage(named: day.icon!)
            cell.labelTemp.text = day.maxTemp
        //    print("temperature \(String(describing: day.maxTemp))")
            return cell
            
        } else {
            return DayCell()
        }
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        let width = (self.startCollection!.bounds.width / 2) - 15
    //        let height = width * (4 / 3)
    //
    //
    //
    //        return CGSize(width: width, height: height)
    //    }
    
}

    
    
    
    

