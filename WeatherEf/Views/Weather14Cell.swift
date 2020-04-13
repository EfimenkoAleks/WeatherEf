//
//  Weather14Cell.swift
//  WeatherEf
//
//  Created by mac on 6/21/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class Weather14Cell: UITableViewCell {
    
    var timeDay: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.backgroundColor = .clear
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
   //     lb.backgroundColor = .green
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    var maxTemp: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.backgroundColor = .clear
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
   //     lb.backgroundColor = .purple
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    var minTemp: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.backgroundColor = .clear
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
   //     lb.backgroundColor = .yellow
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "none")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
   //     self.addSubview(day)
        self.addSubview(timeDay)
        self.addSubview(iconImageView)
        self.addSubview(maxTemp)
        self.addSubview(minTemp)
        
        timeDay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        timeDay.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeDay.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -8).isActive = true
   //     dayWeek.bottomAnchor.constraint(equalTo: day.bottomAnchor).isActive = true
        timeDay.heightAnchor.constraint(equalToConstant: 44).isActive = true
    //    timeDay.widthAnchor.constraint(equalToConstant: self.frame.width / 2).isActive = true
        
        iconImageView.leadingAnchor.constraint(equalTo: timeDay.trailingAnchor, constant: 8).isActive = true
        iconImageView.topAnchor.constraint(equalTo: timeDay.topAnchor).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: maxTemp.leadingAnchor, constant: -8).isActive = true
    //    iconImageView.bottomAnchor.constraint(equalTo: day.bottomAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: timeDay.heightAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        maxTemp.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        maxTemp.topAnchor.constraint(equalTo: timeDay.topAnchor).isActive = true
        maxTemp.trailingAnchor.constraint(equalTo: minTemp.leadingAnchor, constant: -8).isActive = true
     //   maxTemp.bottomAnchor.constraint(equalTo: day.bottomAnchor).isActive = true
        maxTemp.heightAnchor.constraint(equalTo: timeDay.heightAnchor).isActive = true
        maxTemp.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        minTemp.leadingAnchor.constraint(equalTo: maxTemp.trailingAnchor, constant: 8).isActive = true
        minTemp.topAnchor.constraint(equalTo: timeDay.topAnchor).isActive = true
        minTemp.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    //    minTemp.bottomAnchor.constraint(equalTo: day.bottomAnchor).isActive = true
        minTemp.heightAnchor.constraint(equalTo: timeDay.heightAnchor).isActive = true
        minTemp.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
