//
//  ResetPasswordController.swift
//  familiarize
//
//  Created by Alex Oh on 9/26/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class ResetPasswordController: UIViewController, UITextFieldDelegate {
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    
    lazy var resetPasswordButton: UIButton = {
        let button = UIManager.makeTextButton(buttonText: "Reset Password")
        button.addTarget(self, action: #selector(resetPasswordClicked), for: .touchUpInside)
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
        view.addSubview(resetPasswordButton)
        view.addSubview(emailTextField)
        
        outsideButton.frame = view.frame
        
        resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetPasswordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Make keyboard first pop up for the email textfield on presenting the view controller.
        emailTextField.becomeFirstResponder()
    }
    
    func resetPasswordClicked() {
        guard let email = emailTextField.text else { return }
        
        FirebaseManager.resetPassword(email: email) { (error) in
            var alert: UIAlertController?
            if error != nil {
                alert = UIAlertController(title: "Error", message: "Cannot find user with such email", preferredStyle: UIAlertControllerStyle.alert)
                alert?.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert!, animated: true)
            } else {
                alert = UIAlertController(title: "Email Sent", message: "Password reset has been sent to email", preferredStyle: UIAlertControllerStyle.alert)
                alert?.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert!, animated: true)
            }
        }
    }
    
    func outsideClicked() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.emailTextField.endEditing(true)
        })
    }
    
    // When the "done" button is pressed, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        outsideClicked()
        return false
    }
}
