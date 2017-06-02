//
//  FamiliarizeCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class FamiliarizeCell: BaseCell {
//    let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "blank_man")
//        imageView.contentMode = .scaleAspectFit
//        //imageView.backgroundColor = .red
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blank_man")
        imageView.contentMode = .scaleAspectFit
        //imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
