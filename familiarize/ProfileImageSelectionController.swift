//
//  ProfileImageSelectionController.swift
//  familiarize
//
//  Created by Alex Oh on 7/13/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import SwiftyJSON
import RSKImageCropperSwift

class ProfileImageSelectionController: UICollectionViewController, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate, UINavigationControllerDelegate {

    private let cellId = "cellId"
    private let footerCellId = "footerCellId"
    
    // socialMediaProfileImages contains information about which social media it is from and 
    // the data of the social media image.
    var socialMediaProfileImages: [SocialMediaProfileImage]? 
    
    // socialMediaInputs contains all of the information related to the survey inputs that the user 
    // has provided.
    var socialMediaInputs: [SocialMedia]?
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
    }
    
    let selectProfileInstruction: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.text = "Select profile image"
        return label
    }()
    
    lazy var selectButton: UIButton = {
       let button = UIManager.makeButton()
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        let attributedText = NSAttributedString(string: "Confirm", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(attributedText, for: .normal)

        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(selectClicked), for: .touchUpInside)
        return button
    }()
    
    func selectClicked() {
        let initialPinchPoint = CGPoint(x: (self.collectionView?.center.x)! + (self.collectionView?.contentOffset.x)!, y: (self.collectionView?.center.y)! + (self.collectionView?.contentOffset.y)!)
        
        // Select the chosen image from the carousel.
        let selectedIndexPath = collectionView?.indexPathForItem(at: initialPinchPoint)
        let selectedSocialMediaProfileImage = socialMediaProfileImages?[(selectedIndexPath?.item)!]
        
        // Save the new card information into core data.
        let newUserProfile = UserProfile.saveProfileWrapper(socialMediaInputs!, withSocialMediaProfileImage: selectedSocialMediaProfileImage!)

        // When the image chosen is from the camera roll, upload the image to firebase
        // And then update the URL link to that image.
        if (selectedSocialMediaProfileImage?.appName == "default") {
            FirebaseManager.uploadImage(selectedSocialMediaProfileImage!, completionHandler: { fetchedProfileImageURL in
                UserProfile.updateSocialMediaProfileImage(fetchedProfileImageURL, withSocialMediaProfileApp: (selectedSocialMediaProfileImage?.appName)!, withUserProfile: newUserProfile)
                NotificationCenter.default.post(name: .reloadCards, object: nil)
            })
        }
        
        NotificationCenter.default.post(name: .reloadCards, object: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = socialMediaProfileImages?.count {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ProfileImageSelectionCell
        
        if let socialMediaProfileImage = socialMediaProfileImages?[indexPath.item] {
            cell.socialMediaProfileImage = socialMediaProfileImage
        }
        return cell
    }
    
    func setupCollectionView() {
        self.collectionView?.backgroundColor = UIColor.white
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.register(ProfileImageSelectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupViews() {
        view.addSubview(selectProfileInstruction)
        view.addSubview(selectButton)
        
        selectProfileInstruction.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectProfileInstruction.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        selectProfileInstruction.widthAnchor.constraint(equalToConstant: selectProfileInstruction.intrinsicContentSize.width).isActive = true
        selectProfileInstruction.heightAnchor.constraint(equalToConstant: selectProfileInstruction.intrinsicContentSize.height).isActive = true
        
        selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // When only the last default cell is clicked, then the photolibrary pops up. 
    // The defaul cell is created within the Image Fetching Manager.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == collectionView.numberOfItems(inSection: 0)-1 {
            let imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: false, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Delegate Implementation
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false, completion: { () -> Void in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                var imageCropVC : RSKImageCropViewController!
                imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
                imageCropVC.delegate = self
                self.navigationController?.pushViewController(imageCropVC, animated: false)
            }
        })
    }
    
    // MARK: - RSKImageCropperSwift Delegate Implementation
    func didCropImage(_ croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        print("tortilla")
        socialMediaProfileImages?[(collectionView?.numberOfItems(inSection: 0))!-1].profileImage = croppedImage
        collectionView?.reloadData()
        self.navigationController?.popViewController(animated: false)
    }
    
    func didCropImage(_ croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        socialMediaProfileImages?[(collectionView?.numberOfItems(inSection: 0))!-1].profileImage = croppedImage
        collectionView?.reloadData()
        self.navigationController?.popViewController(animated: false)
    }
    
    func didCancelCrop() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func willCropImage(_ originalImage: UIImage) {
        
    }

}

