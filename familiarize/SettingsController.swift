////
////  SettingsController.swift
////  familiarize
////
////  Created by Alex Oh on 6/29/17.
////  Copyright © 2017 nosleep. All rights reserved.
////

import UIKit

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Blank = ""
    case TermsPrivacy = "Terms & Privacy Policy"
    case Contact = "Contact"
    case Help = "Help"
    case Feedback = "Feedback"
}

class SettingsController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var userController: UserController?
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    let settings: [Setting] = {
        return [Setting(name: .Blank, imageName: "dan_buzz_baloo_text"), Setting(name: .Blank, imageName: ""), Setting(name: .TermsPrivacy, imageName: "dan_privacy"),Setting(name: .Contact, imageName: "dan_support"),Setting(name: .Help, imageName: "dan_help"), Setting(name: .Feedback, imageName: "dan_feedback")]
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 21/255, alpha: 1.0)
        return cv
    }()
    
    let websiteQRCodeImage: UIImageView = {
        let imageView = UIManager.makeImage(imageName: "familiarize_website_qr")
        return imageView
    }()
    
    lazy var tintOverlay: UIImageView = {
        let visualEffect = UIManager.makeImage()
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        if let window = UIApplication.shared.keyWindow {
            visualEffect.frame = window.bounds
        }
        return visualEffect
    }()
    
    let buzzText: UIImageView = {
        let imageView = UIManager.makeImage(imageName: "dan_buzz_baloo_text")
        return imageView
    }()
    
    func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tintOverlay.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: (window.frame.width)*(2/3), height: window.frame.height)
            }
            self.userController?.closingHamburger()
            
        }, completion: { _ in
            if setting.name != .Blank {
                self.userController?.showControllerForSetting(setting: setting)
            }
        })
    }
    
    func setupViews() {
        if let window = UIApplication.shared.keyWindow {
            //collectionView.addSubview(websiteQRCodeImage)
            
            window.addSubview(tintOverlay)
            window.addSubview(collectionView)
            collectionView.addSubview(buzzText)
            
            let width: CGFloat = (window.frame.width)*(2/3)
            collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: width, height: window.frame.height)

            
            buzzText.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: -window.frame.width/6).isActive = true
            buzzText.topAnchor.constraint(equalTo: window.topAnchor, constant: 20).isActive = true
            buzzText.widthAnchor.constraint(equalToConstant: 170).isActive = true
            buzzText.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            //websiteQRCodeImage.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant:-window.frame.width/6).isActive = true
            //websiteQRCodeImage.bottomAnchor.constraint(equalTo:  window.bottomAnchor).isActive = true
            //websiteQRCodeImage.heightAnchor.constraint(equalToConstant: width).isActive = true
            //websiteQRCodeImage.widthAnchor.constraint(equalToConstant: width).isActive = true
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.tintOverlay.alpha = 0.15
                self.collectionView.frame = CGRect(x: 0, y: 0, width: width, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.setting = settings[indexPath.item]
        return cell
    }
}
