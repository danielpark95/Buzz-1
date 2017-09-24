//
//  LoginController.swift
//  familiarize
//
//  Created by Alex Oh on 9/22/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import FBSDKLoginKit

class LoginController: UIViewController {
    
    lazy var faceBookLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in With Facebook", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(facebookLoginClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up with email", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(emailLoginClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(faceBookLoginButton)
        view.addSubview(emailLoginButton)
        navigationController?.navigationBar.isHidden = true
        faceBookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceBookLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emailLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        emailLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailLoginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func facebookLoginClicked() {
        FirebaseManager.facebookLogIn(controller: self, loginCompleted: {
            // Present the good shit
            if let window = UIApplication.shared.keyWindow {
                let tabBarController = TabBarController()
                tabBarController.justLoggedIn = true
                print("The tab bar has justLoggedIn set to TRUE")
                window.rootViewController = tabBarController
            }
        })
    }
    
    func emailLoginClicked() {
        
    }
}
