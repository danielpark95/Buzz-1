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
        let button = UIManager.makeTextButton(buttonText: "Sign in with Facebook")
        button.addTarget(self, action: #selector(facebookLoginClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var emailLoginButton: UIButton = {
        let button = UIManager.makeTextButton(buttonText: "Sign up with email")
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(faceBookLoginButton)
        view.addSubview(emailLoginButton)
        
        faceBookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceBookLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emailLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
    }
    
    func facebookLoginClicked() {
        FirebaseManager.facebookLogIn(controller: self, loginCompleted: {
            // Present the good shit
            self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: .loggedInController, object: nil)
        })
    }
    
    func signUpClicked() {
        navigationController?.pushViewController(SignUpEmailController(), animated: true)
    }
}
