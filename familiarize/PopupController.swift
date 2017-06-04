//
//  PopupController.swift
//  familiarize
//
//  Created by Alex Oh on 6/3/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

// Popup -- https://www.youtube.com/watch?v=DmWv-JtQH4Q
// Color -- 37 | 60 | 97


import UIKit

class PopupController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let questionLabel: UILabel = {
        let label =  UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popup-image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var addFriendButton: UIButton = {
        let image = UIImage(named: "add-friend-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectAdd), for: .touchUpInside)
        return button
    }()
    
    func didSelectAdd() {
        self.dismiss(animated: false, completion: {
            let qrScannerController = QRScannerController()
            qrScannerController.selectedAnswerFromPop(true)
        })
    }
    
    lazy var dismissFriendButton: UIButton = {
        let image = UIImage(named: "dismiss-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectDismiss), for: .touchUpInside)
        return button
    }()
    
    func didSelectDismiss() {
        self.dismiss(animated: false, completion: {
            let qrScannerController = QRScannerController()
            qrScannerController.selectedAnswerFromPop(false)
        })
    }
    
    lazy var visualEffectView: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
    func setupView() {
        view.addSubview(visualEffectView)
        view.addSubview(popupImageView)
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        popupImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true

        if (questionLabel.text == "") {
            return
        }
        view.addSubview(questionLabel)
        view.addSubview(addFriendButton)
        view.addSubview(dismissFriendButton)

        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: questionLabel.intrinsicContentSize.height).isActive = true
        questionLabel.widthAnchor.constraint(equalToConstant:questionLabel.intrinsicContentSize.width).isActive = true
        
        addFriendButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20).isActive = true
        addFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addFriendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        dismissFriendButton.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 10).isActive = true
        dismissFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissFriendButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        dismissFriendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

    }
}
