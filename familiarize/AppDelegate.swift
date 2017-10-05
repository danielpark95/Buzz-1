//
//  AppDelegate.swift
//  familiarize
//
//  Created by Alex Oh on 5/27/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData
import ESTabBarController_swift
import Firebase
import Quikkly
import Alamofire
import FBSDKCoreKit

// Firebase messaging
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var previousIndex: Int?
    var userBrightnessLevel: CGFloat!
    var noInternetAccessFrameTopAnchor: NSLayoutConstraint?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Quikkly.apiKey = "sedXkqs5Ak6v2V7yXIs9FCdgbD39IpT5R3FdibJQDnYCbrzJmX6EPbpXcgRX3UH4vV"
        
        // Facebook login setup
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Push notification
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        // For iOS 10 data message (sent via FCM
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        // Firebase setup
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
        
        FirebaseManager.updateFCMToken()

        setupInternetAccessView()
        
        return true
    }
    
    // Notification documents 
    // https://stackoverflow.com/questions/39834018/how-to-send-push-notification-in-ios-10-via-fcmfirebase-or-by-native?rq=1
    
    // For receiving just data
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
    
    // For receiving notification data
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let cardUIDString = notification.request.content.userInfo["gcm.notification.cardUID"] as! String
        let cardUID = UInt64(cardUIDString) ?? 0
        
        FirebaseManager.getCard(withUniqueID: cardUID, completionHandler: { (card, error) in
            guard let card = card else { return }
            if card.count == 0 {
                // Perform some animation to show that the quikkly code is invalid.
                return
            }
            
            // Save the fetched data into CoreData.
            guard let userProfile = UserProfile.saveProfile(card, forProfile: .otherUser, withUniqueID: cardUID) else { return }
            
            // For fetching the profile image picture.
            let socialMedia = SocialMedia(withAppName: (userProfile.profileImageApp)!, withImageName: "", withInputName: (userProfile.profileImageURL)!, withAlreadySet: false)
            
            ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                if let profileImage = fetchedSocialMediaProfileImages[0].profileImage {
                    DiskManager.writeImageDataToLocal(withData: UIImagePNGRepresentation(profileImage)!, withUniqueID: cardUID, withUserProfileSelection: UserProfile.userProfileSelection.otherUser)
                }
            })
        })
        
        completionHandler([.alert, .badge, .sound])
    }
    
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        FirebaseManager.updateFCMToken()
    }
    
    // This bad boy is called whenever a user swipes on the notification!
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if window?.rootViewController as? TabBarController != nil {
            // Must get access to the original tab bar controller.
            let tabBarController = window?.rootViewController as! TabBarController
            // Switch to the third page, which is the contacts page.
            tabBarController.selectedIndex = 2
            // Since the viewdiddisappear doesnt get called within familiarizecontroller, we have to manually display the tab bar.
            tabBarController.tabBar.isHidden = false
        }
        NotificationCenter.default.post(name: .viewProfile, object: nil)
    }
    
    // I do not know what these are for [userNotificationCenter-didReceiveResponse & messaging didReceiveRemoteMessage]. Stackoverflow/firebase documents told me to include these. I will find out later.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    // For opening facebook application on redirection
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    // This is to hardcode the fact that we will only be supporting portrait mode. Say no to landscape mode!
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "familiarize")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func setupInternetAccessView() {
        let noInternetAccessFrame = UIManager.makeImage()
        noInternetAccessFrame.backgroundColor = .red
        let noInternetAccessText = UIManager.makeLabel(numberOfLines: 1, withText: "No Fucking Internet Access")
        noInternetAccessText.textColor = .white
        
        window?.addSubview(noInternetAccessFrame)
        window?.addSubview(noInternetAccessText)
        
        noInternetAccessFrameTopAnchor = noInternetAccessFrame.topAnchor.constraint(equalTo: (window?.topAnchor)!, constant: -20)
        noInternetAccessFrameTopAnchor?.isActive = true
        noInternetAccessFrame.heightAnchor.constraint(equalToConstant: 20).isActive = true
        noInternetAccessFrame.leftAnchor.constraint(equalTo: (window?.leftAnchor)!).isActive = true
        noInternetAccessFrame.rightAnchor.constraint(equalTo: (window?.rightAnchor)!).isActive = true
        
        noInternetAccessText.topAnchor.constraint(equalTo: noInternetAccessFrame.topAnchor).isActive = true
        noInternetAccessText.centerXAnchor.constraint(equalTo: noInternetAccessFrame.centerXAnchor).isActive = true
        
        let manager = NetworkReachabilityManager(host: "www.google.com")
        manager?.listener = { status in
            // If the network is not reachable through internet, then show the no internet access sign.
            if (manager?.isReachable == false) {
                self.noInternetAccessFrameTopAnchor?.constant = 0
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.window?.windowLevel = UIWindowLevelStatusBar + 1
                    self.window?.layoutIfNeeded()
                }, completion: nil)
            } else {
            // If the network is reachable through internet, then show the no internet access sign.
                self.noInternetAccessFrameTopAnchor?.constant = -20
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.window?.windowLevel = UIWindowLevelStatusBar - 1
                    self.window?.layoutIfNeeded()
                }, completion: nil)
            }
        }
        manager?.startListening()
    }
}

