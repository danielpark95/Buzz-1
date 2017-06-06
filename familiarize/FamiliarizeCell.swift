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
            "name": "Jim Bean",
            "fb": "alexswoh",
            "ig": "alexswozi",
            "sc": "alexoooh",
            "pn": "2136041187",
            ]
        return qrJSON.rawString()!
    }
    
    lazy var qrImageView: UIImageView = {
        var qrCode = QRCode(self.createJSON())
        qrCode?.backgroundColor = CIColor(red: 242/255, green: 242/255, blue: 242/255)
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
