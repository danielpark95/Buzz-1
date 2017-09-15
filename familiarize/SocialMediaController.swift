//
//  SocialMediaController.swift
//  familiarize
//
//  Created by Alex Oh on 7/6/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class SocialMediaController: UIViewController, UITextFieldDelegate {
    
    var newCardControllerDelegate: NewCardController?
    var socialMedia: SocialMedia?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //inputTextField.delegate = self
        
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    // After all of the views are setups, then animate the motion where the popup image
    // starts to rise up from the bottom of the screen to the middle.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animatePopup()
        // Makes the inputTextField show up immendiately when the social media icon is pressed.
        inputTextField.becomeFirstResponder()
        
        //inputTextField.delegate = self
        //inputTextField.delegate = self
        
        
    }
    
    lazy var addButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_save")
        button.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        return button
    }()
    
    var popupImageView: UIImageView = {
        let imageView = UIManager.makeImage()
        imageView.image = UIImage(named: "dan_profilepopup_square")
        let tap = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let socialMediaImageView: UIImageView = {
        return UIManager.makeImage()
    }()
    
    lazy var tintOverlay: UIImageView = {
        let visualEffect = UIManager.makeImage()
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()

    lazy var outsideButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        //change to "name" and "bio" for name and bio. username doesn't really make sense.
        textField.placeholder = "username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.tintColor = UIColor(white: 0.55, alpha: 1)
        textField.textAlignment = NSTextAlignment.center
        
        
        
        return textField
    }()
    
    func addClicked() {
        socialMedia?.inputName = inputTextField.text!
        newCardControllerDelegate?.addSocialMediaInput(socialMedia: socialMedia!, new: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    func dismissClicked() {
        self.popupCenterYAnchor?.constant = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tintOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.inputTextField.endEditing(true)
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            self.dismiss(animated: false)
        })
    }
    
    // Slides up the popup from the bottom of the screen to the middle
    func animatePopup() {
        self.popupCenterYAnchor?.constant = -40
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tintOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        }, completion: nil)
    }
    
//    let limitLength = 20
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return true }
//        let newLength = text.characters.count + string.characters.count - range.length
//        return newLength <= limitLength
//    }
//    
    var popupCenterYAnchor: NSLayoutConstraint?
    func setupViews() {
        view.addSubview(tintOverlay)
        view.addSubview(outsideButton)
        view.addSubview(popupImageView)
        view.addSubview(addButton)
        view.addSubview(socialMediaImageView)
        view.addSubview(inputTextField)

        outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        popupCenterYAnchor?.isActive = true
        
        addButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 75).isActive = true
        
        socialMediaImageView.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        socialMediaImageView.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -50).isActive = true
        //socialMediaImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //socialMediaImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputTextField.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 20).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: popupImageView.intrinsicContentSize.width - 80).isActive = true
        
        socialMediaImageView.image = UIImage(named: (socialMedia?.imageName)!)
    }
    
}
