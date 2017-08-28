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

class NewCardController: UIViewController, NewCardControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let profileImageSelectionCellId = "profileImageSelectionCellId"
    private let socialMediaSelectionCellId = "socialMediaSelectionCellId"
    private let socialMediaSelectedCellId = "socialMediaSelectedCellId"
    
    private enum tableViewTag: Int {
        case profileImageSelectionTableView
        case socialMediaSelectionTableView
        case socialMediaSelectedTableView
    }

    
//    lazy var profileImageSelectionTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
//        tableView.alwaysBounceVertical = true
//        tableView.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: self.profileImageSelectionCellId)
//        tableView.backgroundColor = .white
//        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
//        return tableView
//    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var socialMediaSelectionTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SocialMediaSelectionCell.self, forCellReuseIdentifier: self.socialMediaSelectionCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tag = tableViewTag.socialMediaSelectionTableView.rawValue
        tableView.layer.cornerRadius = 27
        tableView.layer.masksToBounds = true
        tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        return tableView
    }()
    
    lazy var socialMediaSelectedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.alwaysBounceVertical = false
        tableView.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: self.socialMediaSelectedCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tag = tableViewTag.socialMediaSelectedTableView.rawValue
        
        return tableView
    }()

    var socialMediaInputs: [SocialMedia] = [
        SocialMedia(withAppName: "name", withImageName: "dan_name_black", withInputName: "Required", withAlreadySet: true),
        SocialMedia(withAppName: "bio", withImageName: "dan_bio_black", withInputName: "Optional", withAlreadySet: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.black
        setupView()
        setupNavBarButton()
    }
    
    
    func setupView() {
        view.addSubview(containerView)
        view.addSubview(socialMediaSelectionTableView)
        view.addSubview(socialMediaSelectedTableView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        

        containerView.addSubview(socialMediaSelectionTableView)
        
        
        socialMediaSelectionTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        socialMediaSelectionTableView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
         socialMediaSelectionTableView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        socialMediaSelectionTableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        socialMediaSelectedTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectedTableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        socialMediaSelectedTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        socialMediaSelectedTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
    }

    //# MARK: - Body Table View
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tableViewTag.socialMediaSelectionTableView.rawValue {
            return 60
        } else if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tableViewTag.socialMediaSelectionTableView.rawValue {
            return 1
        } else if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            return socialMediaInputs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tableViewTag.socialMediaSelectionTableView.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
            cell.newCardControllerDelegate = self
            return cell
        } else { //if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue
            let cell = tableView.dequeueReusableCell(withIdentifier: socialMediaSelectedCellId, for: indexPath) as! SocialMediaSelectedCell
            cell.selectedSocialMedia = socialMediaInputs[indexPath.item]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            self.presentSocialMediaPopup(socialMedia: socialMediaInputs[indexPath.item])
        }
    }
    
    // This method is needed when a row is fixed to not be deleted.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        socialMediaInputs.remove(at: indexPath.item)
        tableView.reloadData()
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
        socialMediaSelectedTableView.reloadData()
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

