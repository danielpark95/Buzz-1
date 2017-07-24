//
//  TermsPrivacyController.swift
//  familiarize
//
//  Created by Alex Oh on 7/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
class TermsPrivacySettingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    
    
    override func viewWillAppear(_ animated: Bool) {
//        let navigationTitleFont = UIFont(name: "Avenir", size: 17)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont!,NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)]
//        
//        //UINavigationBar.appearance().tintColor = color
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navigationTitleFont!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)]
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0), NSFontAttributeName: navigationTitleFont!], forState: UIControlState.Normal)
//
//        
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0), NSFontAttributeName: UIFont(name: "Avenir", size: 30)!]
        //navigationItem.title = "Terms & Privacy Policy"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.white
        
        setupNavBarButton()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func setupNavBarButton() {
        let backButton = UIBarButtonItem(image: UIImage(named:"back-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
