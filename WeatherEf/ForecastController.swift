//
//  ForecastController.swift
//  WeatherEf
//
//  Created by mac on 11.08.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class ForecastController: UIViewController {
    
    @IBOutlet weak var time1Label : UILabel!
    @IBOutlet weak var time2Label : UILabel!
    @IBOutlet weak var time3Label : UILabel!
    @IBOutlet weak var time4Label : UILabel!
    
    @IBOutlet weak var temp1Label : UILabel!
    @IBOutlet weak var temp2Label : UILabel!
    @IBOutlet weak var temp3Label : UILabel!
    @IBOutlet weak var temp4Label : UILabel!
    
    @IBOutlet weak var icon1View: UIImageView!
    @IBOutlet weak var icon2View: UIImageView!
    @IBOutlet weak var icon3View: UIImageView!
    @IBOutlet weak var icon4View: UIImageView!
    
    var time1: String!
    var time2: String!
    var time3: String!
    var time4: String!
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    var temp4: String!
    
    var icon1Image: UIImageView!
    var icon2Image: UIImageView!
    var icon3Image: UIImageView!
    var icon4Image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         self.time1Label.text = self.time1
         self.time2Label.text = self.time2
         self.time3Label.text = self.time3
         self.time4Label.text = self.time4
        
        self.icon1View.image = self.icon1Image.image
        self.icon2View.image = self.icon2Image.image
        self.icon3View.image = self.icon3Image.image
        self.icon4View.image = self.icon4Image.image
        
        self.temp1Label.text = self.temp1
        self.temp2Label.text = self.temp2
        self.temp3Label.text = self.temp3
        self.temp4Label.text = self.temp4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
