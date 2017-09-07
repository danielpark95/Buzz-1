//
//  UserController.swift
//  familiarize
//
//  Created by Alex Oh on 6/17/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

extension Notification.Name {
    static let reloadMeCards = Notification.Name("reloadMeCards")
}

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let cellId = "cellId"
    var blockOperations = [BlockOperation]()
    
    // This is so that the dots that animate your current location can be seen. Amazing piece of art (:
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        pc.pageIndicatorTintColor = UIColor(red: 222/255, green: 223/255, blue: 224/255, alpha: 1.0)
        pc.currentPageIndicatorTintColor = UIColor(red:139/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1.0)
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.predicate = NSPredicate(format: "userProfileSelection == %@", argumentArray: [UserProfile.userProfileSelection.myUser.rawValue])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMeCards), name: .reloadMeCards, object: nil)
        navigationItem.title = "Me"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 20)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 0
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //UserProfile.clearData(forProfile: .myUser)
        //UserProfile.clearData(forProfile: .otherUser)
        //UserProfile.saveProfile(user2, forProfile: .myUser)
        //UserProfile.saveProfile(user1, forProfile: .myUser)

        setupView()
        setupNavBarButton()
        setupCollectionView()
        
        let doubleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didDoubleTapCollectionView))
        doubleTapGesture.numberOfTapsRequired = 2
        collectionView?.addGestureRecognizer(doubleTapGesture)
    }
    
    func reloadMeCards() {
        // This does not fucking work ):
        collectionView?.reloadData()
    }
    
    // This is for when use double taps on the screen, then the card flips around to reveal whatever the behind screen is. 
    func didDoubleTapCollectionView(_ gesture: UITapGestureRecognizer) {
        let pointInCollectionView = gesture.location(in: collectionView)
        let selectedIndexPath = collectionView?.indexPathForItem(at: pointInCollectionView)
        let selectedCell = collectionView?.cellForItem(at: selectedIndexPath!) as! UserCell
        selectedCell.onQRImage = !(selectedCell.onQRImage)
        selectedCell.flipCard()
    }
    
    func setupNavBarButton() {
        let editButton = UIBarButtonItem(image: UIImage(named:"dan_editbutton_yellow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editCard))
        let addButton = UIBarButtonItem(image: UIImage(named:"dan_addbutton_yellow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addCard))
        
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    func editCard() {
        
        let newCardController = NewCardController()
        let navigationController = UINavigationController(rootViewController: newCardController)
        newCardController.socialMediaInputs.removeAll(keepingCapacity: true)
        newCardController.navigationItem.title = "Edit Card"
        
        let initialPinchPoint = CGPoint(x: (self.collectionView?.center.x)! + (self.collectionView?.contentOffset.x)!, y: (self.collectionView?.center.y)! + (self.collectionView?.contentOffset.y)!)
        
        // Select the chosen image from the collectionview
        let selectedIndexPath = collectionView?.indexPathForItem(at: initialPinchPoint)
        let userProfile = fetchedResultsController.object(at: selectedIndexPath!) as! UserProfile
        
        for key in userProfile.entity.propertiesByName.keys {
            guard let inputName = userProfile.value(forKey: key) else {
                continue
            }
            if UserProfile.editableMultipleInputUserData.contains(key) {
                for eachInput in inputName as! [String] {
                    let socialMediaInput = SocialMedia(withAppName: key, withImageName: "dan_\(eachInput)_black", withInputName: eachInput, withAlreadySet: true)
                    newCardController.socialMediaInputs.append(socialMediaInput)
                }
            } else if UserProfile.editableSingleInputUserData.contains(key) {
                let socialMediaInput = SocialMedia(withAppName: key, withImageName: "dan_\(inputName)_black", withInputName: inputName as! String, withAlreadySet: true)
                newCardController.socialMediaInputs.append(socialMediaInput)
            }
        }
        
        for socialMediaInput in newCardController.socialMediaInputs {
            newCardController.addSocialMediaInput(socialMedia: socialMediaInput, new: true)
        }
        
        self.present(navigationController, animated: true)
    }
    
    func addCard() {
        let newCardController = NewCardController()
        let navigationController = UINavigationController(rootViewController: newCardController)
        newCardController.navigationItem.title = "New Card"
        self.present(navigationController, animated: true)
    }

    func setupView() {
        // Add the dots that animate your current location with the qrcodes into the view
        view.addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupCollectionView() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: self.cellId)
        collectionView?.isPagingEnabled = true
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: nil)
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Modify this after you saved a user.
        if let count = fetchedResultsController.sections?.first?.numberOfObjects {
            pageControl.numberOfPages = count
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! UserCell
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        cell.myUserProfile = userProfile
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView!.frame.size;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

