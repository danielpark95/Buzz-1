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
    
    lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIManager.makeTextButton(buttonText: "Already Have an account? Log in")
        button.addTarget(self, action: #selector(alreadyHaveAccountClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var outsideButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(outsideClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(outsideButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(alreadyHaveAccountButton)
        
        outsideButton.frame = view.frame
        
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -170).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        
        alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyHaveAccountButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Make keyboard first pop up for the email textfield on presenting the view controller.
        emailTextField.becomeFirstResponder()
    }
    
    func outsideClicked() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.emailTextField.endEditing(true)
            self.passwordTextField.endEditing(true)
        })
    }
    
    // When the "done" button is pressed, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        outsideClicked()
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
        
            self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: .loggedInController, object: nil)
        }
    }
    
    func alreadyHaveAccountClicked() {
        navigationController?.pushViewController(LogInEmailController(), animated: true)
    }
}
