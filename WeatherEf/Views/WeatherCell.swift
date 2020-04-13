//
//  WeatherCell.swift
//  WeatherEf
//
//  Created by mac on 6/18/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {

    var label: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.backgroundColor = .clear
//        lb.shadowColor = .purple
//        let size = CGSize(width: 0, height: -1)
//        lb.shadowOffset = size
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var detailLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 25)
        lb.backgroundColor = .clear
//        lb.shadowColor = .purple
//        let size = CGSize(width: 0, height: -1)
//        lb.shadowOffset = size
        lb.layer.cornerRadius = 8
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        self.addSubview(detailLabel)
        
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        detailLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16).isActive = true
        detailLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

}

