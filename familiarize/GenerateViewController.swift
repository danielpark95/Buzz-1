//
//  GenerateViewController.swift
//  Samples
//
//  Created by Julian Gruber on 06/03/2017.
//  Copyright © 2017 Quikkly Ltd. All rights reserved.
//
import UIKit
import Quikkly
import SwiftyJSON

class GenerateViewController: UIViewController {
    
    var scannableView:ScannableView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Generate"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.scannableView = ScannableView(frame: CGRect())
        self.view.addSubview(self.scannableView)
        
        
        let user1: JSON = [
            "name": "T.J. Miller",
            "pn": "pn",
            "fb": "100015503711138",
            "sc": "sc",
            "ig": "ig",
            "so": "so",
            "tw": "tw",
            "bio": "Miller the professional chiller."
        ]
        
        let date = Date()
        let calendar = Calendar.current
        
        
        let year = calendar.component(.year, from: date)%100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let milliseconds = calendar.component(.nanosecond, from: date)/100
        let randomNumber = Int(arc4random())%1000
        
        let uniqueIDString = String(format: "%i%i%i%i%i%i%i%i", arguments: [year,
                                                                          month,
                                                                          day,
                                                                          hour,
                                                                          minutes,
                                                                          seconds,
                                                                          milliseconds,
                                                                          randomNumber])
        
        let uniqueIDNumber = UInt64(uniqueIDString)

        FirebaseManager.uploadCard(user1, withUniqueID: uniqueIDNumber!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let skin = ScannableSkin()
        skin.backgroundColor = "#ffffff"
        skin.maskColor = "#ffffff"
        skin.dotColor = "#58595b"
        skin.borderColor = "#58595b"
        skin.overlayColor = "#58595b"
        skin.imageUri = "https://s3-eu-west-1.amazonaws.com/qkly-service-albums/temp_icons/squiddy.png"
        skin.imageFit = .templateDefault
        skin.logoUri = ""
        
        let scannable = Scannable(withValue: 94637505, template: "template0015style2", skin: skin)

        self.scannableView.scannable = scannable
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var rect = CGRect()
//        
//        rect.size.width = self.view.frame.size.width
//        rect.size.height = self.view.frame.size.height*0.33
//        rect.origin.x = self.view.frame.size.width*0.5 - rect.size.width*0.5
//        rect.origin.y = self.view.frame.size.height*0.5 - rect.size.height*0.5
        self.scannableView.translatesAutoresizingMaskIntoConstraints = false
        self.scannableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.scannableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.scannableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.scannableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //self.scannableView.frame = rect
    }
    
}
