//
//  NewCardController.swift
//  familiarize
//
//  Created by Alex Oh on 7/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

protocol NewCardControllerDelegate {
    func presentSocialMediaPopup(socialMedia: SocialMedia) -> Void
    func addSocialMediaInput(socialMedia: SocialMedia) -> Void
}

class NewCardController: UITableViewController, NewCardControllerDelegate {

    var socialMediaInputs: [SocialMedia] = [
        SocialMedia(withAppName: "name", withImageName: "name_form", withInputName: "Required", withAlreadySet: true),
        SocialMedia(withAppName: "bio", withImageName: "bio_form", withInputName: "Optional", withAlreadySet: true)
    ]
    
    private let socialMediaSelectionCellId = "socialMediaSelectionCellId"
    private let socialMediaSelectedCellId = "socialMediaSelectedCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Card"
        navigationController?.navigationBar.tintColor = UIColor.black
        setupTableView()
        setupNavBarButton()
    }
    
    //# MARK: - Header Table View
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Add"
        } else {
            return "My Info"
        }
    }
    
    //# MARK: - Body Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return socialMediaInputs.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
            cell.newCardControllerDelegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: socialMediaSelectedCellId, for: indexPath) as! SocialMediaSelectedCell
            cell.selectedSocialMedia = socialMediaInputs[indexPath.item]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.presentSocialMediaPopup(socialMedia: socialMediaInputs[indexPath.item])
        }
    }
    
    // This method is needed when a row is fixed to not be deleted.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        socialMediaInputs.remove(at: indexPath.item)
        tableView.reloadData()
    }
    
    //# MARK: - Setup Views
    func setupTableView() {
        tableView?.alwaysBounceVertical = true
        tableView?.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: socialMediaSelectedCellId)
        tableView?.register(SocialMediaSelectionCell.self, forCellReuseIdentifier: socialMediaSelectionCellId)
        tableView?.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func setupNavBarButton() {
        let cancelButton = UIBarButtonItem.init(title: "cancel", style: .plain, target: self, action: #selector(cancelClicked))
        let nextButton = UIBarButtonItem.init(title: "next", style: .plain, target: self, action: #selector(nextClicked))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentSocialMediaPopup(socialMedia: SocialMedia) {
        let socialMediaController = SocialMediaController()
        socialMediaController.socialMedia = socialMedia
        socialMediaController.newCardControllerDelegate = self
        socialMediaController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.definesPresentationContext = true
        navigationController?.present(socialMediaController, animated: false)
    }
    
    //# Mark: - Stored Info
    
    // For adding it to the Table view.
    func addSocialMediaInput(socialMedia: SocialMedia) {
        // TODO: Valid name checker. 
        // i.e. no blank usernames.
        if socialMedia.inputName != "" && socialMedia.isSet == false {
            let newSocialMediaInput = SocialMedia(copyFrom: socialMedia)
            newSocialMediaInput.isSet = true
            socialMediaInputs.append(newSocialMediaInput)
        }
        tableView?.reloadData()
    }
    
    // For adding it to the coredata
    func nextClicked() {
        //socialMediaInputs.sort(by: { $0.appName! < $1.appName! })
        //# MARK: - Presenting ProfileImageSelectionController
        let loadingProfileImageSelectionController = LoadingProfileImageSelectionController()
        loadingProfileImageSelectionController.socialMediaInputs = socialMediaInputs
        navigationController?.pushViewController(loadingProfileImageSelectionController, animated: true)
    }
}

