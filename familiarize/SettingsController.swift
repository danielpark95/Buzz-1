////
////  SettingsController.swift
////  familiarize
////
////  Created by Alex Oh on 6/29/17.
////  Copyright © 2017 nosleep. All rights reserved.
////
//
//
////
////  SettingsController.swift
////  familiarize
////
////  Created by Alex Oh on 6/29/17.
////  Copyright © 2017 nosleep. All rights reserved.
////
//
//import UIKit
//
class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}


//
//
//class SettingsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//    private let cellId = "cellId"
//
//    let settings: [Setting] = {
//        return [Setting(name: "", imageName: ""),Setting(name: "Terms & privacy policy", imageName: "privacy"),Setting(name: "Contact", imageName: "contact"),Setting(name: "Help", imageName: "help"), Setting(name: "Feedback", imageName: "feedback")]
//    }()
//
//    let whatImage: UIImageView = {
//       return UIManager.makeImage(imageName: "privacy")
//    }()
//
//    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.title = "Settings"
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(whatImage)
//
//        whatImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        whatImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        whatImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        whatImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
//
//
//        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView?.backgroundColor = UIColor.white
//
//        setupNavBarButton()
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return settings.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! SettingsCell
//
//        let setting = settings[indexPath.item]
//        cell.setting = setting
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if (indexPath.item == 0) {
//            return CGSize(width: view.frame.width, height: 100)
//        }
//        return CGSize(width: view.frame.width, height: 50)
//    }
//
//
//    func setupNavBarButton() {
//        let backButton = UIBarButtonItem(image: UIImage(named:"back-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
//        navigationItem.leftBarButtonItem = backButton
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func handleBack() {
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        view.window!.layer.add(transition, forKey: kCATransition)
//
//        self.dismiss(animated: false, completion: nil)
//    }
//
//
//}

enum SettingName: String {
    case Blank = ""
    case TermsPrivacy = "Terms & Privacy Policy"
    case Contact = "Contact"
    case Help = "Help"
    case Feedback = "Feedback"
}

import UIKit
class SettingsController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    var userController: UserController?
    
    let topImage: UIImageView = {
        return UIManager.makeImage(imageName: "privacy")
    }()
    
    let settings: [Setting] = {
        return [Setting(name: .Blank, imageName: ""),Setting(name: .TermsPrivacy, imageName: "dan_privacy"),Setting(name: .Contact, imageName: "dan_support"),Setting(name: .Help, imageName: "dan_help"), Setting(name: .Feedback, imageName: "dan_feedback")]
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let tintOverlay = UIView()
    
    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            tintOverlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
            tintOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(tintOverlay)
            window.addSubview(collectionView)
            let width: CGFloat = (window.frame.width)*(2/3)
            let x = window.frame.width - width
            collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: width, height: window.frame.height)
            tintOverlay.frame = window.frame
            tintOverlay.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.tintOverlay.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: width, height: window.frame.height)
                
            }, completion: nil)
        }
    }
    
    func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tintOverlay.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: (window.frame.width)*(2/3), height: window.frame.height)
            }
            
        }, completion: { _ in
            if setting.name != .Blank {
                self.userController?.showControllerForSetting(setting: setting)
            }
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.setting = settings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.item == 0) {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
        
        
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
}
