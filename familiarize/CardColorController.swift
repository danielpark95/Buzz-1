//
//  CardColorController.swift
//  familiarize
//
//  Created by Alex Oh on 10/12/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class CardColorController: UIViewController {
    
    var newCardControllerDelegate: NewCardControllerDelegate?
    
    var cardType: CardType? {
        didSet {
            beeView.tintColor = cardType?.cardColor
        }
    }
    
    let beeView: UIImageView = {
        let imageView = UIManager.makeImage(imageName: "bee_icon")
        imageView.image = imageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    // After all of the views are setups, then animate the motion where the popup image
    // starts to rise up from the bottom of the screen to the middle.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animatePopup()
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
    
    func addClicked() {
        if let cardType = cardType {
            newCardControllerDelegate?.updateCardType(cardType: cardType)
        }
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
    
    var popupCenterYAnchor: NSLayoutConstraint?
    func setupViews() {
        view.addSubview(tintOverlay)
        view.addSubview(outsideButton)
        view.addSubview(popupImageView)
        view.addSubview(addButton)
        view.addSubview(beeView)
        
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
        
        beeView.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        beeView.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -50).isActive = true
        
    }
    
}
