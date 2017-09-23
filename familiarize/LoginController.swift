//
//  LoginController.swift
//  familiarize
//
//  Created by Alex Oh on 9/22/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import FBSDKLoginKit
import Firebase

class LoginController: UIViewController {
    
    lazy var faceBookLoginButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_close_button_v2")
        button.addTarget(self, action: #selector(facebookLoginClicked), for: .touchUpInside)
        button.backgroundColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(faceBookLoginButton)
        faceBookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceBookLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func facebookLoginClicked() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // Present the main view
                if let window = UIApplication.shared.keyWindow {
                    window.rootViewController = TabBarController()
                }
            })
            
        }
    }
}
