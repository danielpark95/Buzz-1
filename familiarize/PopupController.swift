//
//  PopupController.swift
//  familiarize
//
//  Created by Alex Oh on 6/3/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class PopupController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blank_man")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupView() {
        view.addSubview(popupImageView)
        
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        popupImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
}
