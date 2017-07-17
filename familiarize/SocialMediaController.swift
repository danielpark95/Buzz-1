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
    
    var newCardControllerDelegate: NewCardController?
    var socialMedia: SocialMedia? {
        didSet {
            if let socialMediaImageName = socialMedia?.imageName {
                socialMediaImageView.image = UIImage(named: socialMediaImageName)
                
                // Do we need this?
                //socialMediaImageView.clipsToBounds = true
            }
            setupViews()
        }
    }
    
    // When everything is done loading, do this shabang.
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let button = UIManager.makeButton()
        //button.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        //button.layer.cornerRadius = 13
        let attributedText = NSAttributedString(string: "save", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        button.reversesTitleShadowWhenHighlighted = true
        return button
    }()
    
    func addClicked() {
        socialMedia?.inputName = inputTextField.text!
        newCardControllerDelegate?.addSocialMediaInput(socialMedia: socialMedia!)
        self.dismiss(animated: false, completion: nil)
    }
    
    var popupImageView: UIImageView = {
        let imageView = UIManager.makeImage()
        imageView.image = UIImage(named: "dan_popup_smallest")
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
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.2)
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
    
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }

    func setupViews() {
        view.addSubview(self.tintOverlay)
        view.addSubview(self.outsideButton)
        view.addSubview(self.popupImageView)
        view.addSubview(self.addButton)
        view.addSubview(self.socialMediaImageView)
        view.addSubview(self.inputTextField)

        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
        //self.popupImageView.heightAnchor.constraint(equalToConstant: 182).isActive = true
        //self.popupImageView.widthAnchor.constraint(equalToConstant: 217).isActive = true
        
        self.addButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        self.addButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 75).isActive = true
        //self.addButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        //self.addButton.widthAnchor.constraint(equalToConstant: 150).isActive = true

        
        self.socialMediaImageView.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        self.socialMediaImageView.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -50).isActive = true
        self.socialMediaImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.socialMediaImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputTextField.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 10).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.width).isActive = true
        
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
    
    
}
