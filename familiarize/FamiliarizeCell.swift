//
//  FamiliarizeCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import QRCode
import SwiftyJSON
import UIKit

// You need to convert the JSON string to a data and then intialize it to create a json object! 


class FamiliarizeCell: BaseCell {
    
    func createJSON() -> String {
        let qrJSON: JSON = [
            "name": "Alex Oh",
            "fb": "alexswoh",
            "ig": "alexswozi",
            "sc": "alexoooh",
            "pn": "2136041187",
            "bio": "\"And this is how my life started\"",
            ]
        return qrJSON.rawString()!
    }
    
    lazy var qrImageView: UIImageView = {
        var qrCode = QRCode(self.createJSON())
        qrCode?.color = CIColor.white()
        qrCode?.backgroundColor = CIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
        let imageView = UIImageView()
        imageView.image = qrCode?.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(qrImageView)
        qrImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        qrImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        qrImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        qrImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true

    }
    
}
