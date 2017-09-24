//
//  SignUpController.swift
//  familiarize
//
//  Created by Alex Oh on 9/23/17.
//  Copyright © 2017 nosleep. All rights reserved.
//
import UIKit

class SignUpEmailController: UIViewController, UITextFieldDelegate {
    
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIManager.makeTextButton(buttonText: "Sign Up")
        button.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
    }
    
    // When the "done" button is pressed, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func signUpClicked() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        FirebaseManager.signUp(email: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let window = UIApplication.shared.keyWindow {
                let tabBarController = TabBarController()
                tabBarController.justLoggedIn = true
                window.rootViewController = tabBarController
            }
        }
    }
}
