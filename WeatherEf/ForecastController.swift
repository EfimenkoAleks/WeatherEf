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
    
    @IBOutlet weak var viewForecast: UIView!
    
    var time1: String!
    var time2: String!
    var time3: String!
    var time4: String!
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    var temp4: String!
    
    var icon1Image: UIImage!
    var icon2Image: UIImage!
    var icon3Image: UIImage!
    var icon4Image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewForecast.layer.cornerRadius = self.viewForecast.frame.size.width / 8
        self.viewForecast.clipsToBounds = true
        
        //Set animation view
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform.init(translationX: 0.0, y: 500.0)
        self.viewForecast.transform = scale.concatenating(translate)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [], animations: {
            let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let translate = CGAffineTransform.init(translationX: 0.0, y: 0.0)
            self.viewForecast.transform = scale.concatenating(translate)
        }, completion: nil)
       
        
         self.time1Label.text = self.time1
         self.time2Label.text = self.time2
         self.time3Label.text = self.time3
         self.time4Label.text = self.time4
        
        self.icon1View.image = self.icon1Image
        self.icon2View.image = self.icon2Image
        self.icon3View.image = self.icon3Image
        self.icon4View.image = self.icon4Image
        
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
