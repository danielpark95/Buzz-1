//
//  SocialMediaController.swift
//  familiarize
//
//  Created by Alex Oh on 7/6/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class SocialMediaController: UIViewController {
    
    // When everything is done loading, do this shabang.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupInputComponents()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    // After all of the views are setups, then animate the motion where the popup image
    // starts to rise up from the bottom of the screen to the middle.
    override func viewDidAppear(_ animated: Bool) {
        self.animatePopup()
        
        // Makes the inputTextField show up immendiately when the social media icon is pressed.
        inputTextField.becomeFirstResponder()
    }
    
    lazy var addButton: UIButton = {
        let button = UIManager.makeButton(imageName: "addfriend-button")
        button.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        return button
    }()
    
    func addClicked() {
        print(inputTextField.text!)
    }
    
    var popupImageView: UIImageView = {
        let imageView = UIManager.makeImage()
        imageView.image = UIImage(named: "view-profile-popup")
        let tap = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var tintOverlay: UIImageView = {
        let visualEffect = UIManager.makeImage()
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()

    
    lazy var outsideButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    func dismissClicked() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Slides up the popup from the bottom of the screen to the middle
    var popupCenterYAnchor: NSLayoutConstraint?
    var inputTextFieldCenterYAnchor: NSLayoutConstraint?
    
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        inputTextFieldCenterYAnchor?.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            //self.setupGraphics()
            //self.addToGraphics()
            
        })
        
    }

    func setupViews() {
        
        view.addSubview(self.tintOverlay)
        view.addSubview(self.outsideButton)
        view.addSubview(self.popupImageView)
        view.addSubview(self.addButton)

        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 182).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 217).isActive = true
        
        self.addButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        self.addButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 40).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.tintColor = UIColor(white: 0.55, alpha: 1)
        textField.textAlignment = NSTextAlignment.center
        
        return textField
    }()
    
    func setupInputComponents() {
        view.addSubview(inputTextField)
        inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputTextFieldCenterYAnchor = inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        inputTextFieldCenterYAnchor?.isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.width).isActive = true
    }
    
}
