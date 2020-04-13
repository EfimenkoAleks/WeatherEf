//
//  DayCell.swift
//  WeatherEf
//
//  Created by user on 6/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    
    var imageView: UIImageView = {
        let imageView1 = UIImageView()
        imageView1.image = UIImage(named: "none")
        //  let imageTemp = imageView1.image?.withRenderingMode(.alwaysTemplate)
        //  imageView1.image = imageTemp
        // imageView1.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.layer.cornerRadius = 16
        imageView1.layer.masksToBounds = true
        imageView1.contentMode = .scaleAspectFit
        imageView1.backgroundColor = .white
        //    imageView1.layer.borderWidth = 1
        return imageView1
    }()
    
    var labelTemp: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 17)
        // lb.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 30)
        lb.backgroundColor = .clear
        lb.textColor = .white
        lb.layer.cornerRadius = 10
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var labelTime: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 17)
        // lb.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 30)
        lb.backgroundColor = .clear
        lb.textColor = .white
        lb.layer.cornerRadius = 10
        lb.layer.masksToBounds = true
        lb.numberOfLines = 1
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
//    let separotorHorizontal: UIView = {
//        let sp = UIView()
//        sp.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
//        sp.translatesAutoresizingMaskIntoConstraints = false
//        return sp
//    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(labelTime)
        self.addSubview(labelTemp)
        
        //   label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        labelTime.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //   label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -8).isActive = true
        labelTime.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //    label.widthAnchor.constraint(equalToConstant: self.frame.width * 0.3).isActive = true
        
        
        //   imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //  imageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: labelTemp.topAnchor, constant: -8).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        //   label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        labelTemp.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        //   label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -8).isActive = true
        labelTemp.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //    label.widthAnchor.constraint(equalToConstant: self.frame.width * 0.3).isActive = true
        
 

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
