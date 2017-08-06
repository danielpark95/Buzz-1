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
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        let uniqueID = FirebaseManager.generateUniqueID()
        FirebaseManager.uploadCard(user1, withUniqueID: uniqueID)
        
        let skin = ScannableSkin()
        skin.backgroundColor = "#ffffff"
        skin.maskColor = "#ffffff"
        skin.dotColor = "#58595b"
        skin.borderColor = "#58595b"
        skin.overlayColor = "#58595b"
        skin.imageUri = "https://s3-eu-west-1.amazonaws.com/qkly-service-albums/temp_icons/squiddy.png"
        skin.imageFit = .templateDefault
        skin.logoUri = ""
        
        let scannable = Scannable(withValue: uniqueID, template: "template0015style2", skin: skin)

        self.scannableView.scannable = scannable
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scannableView.translatesAutoresizingMaskIntoConstraints = false
        self.scannableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.scannableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.scannableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.scannableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
}
