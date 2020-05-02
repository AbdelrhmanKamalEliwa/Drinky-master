//
//  RegisterViewController.swift
//  Drinky
//
//  Created by Awady on 4/30/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var fristNameTextField: UITextField!
    @IBOutlet weak var fristNameLabel: UILabel!
    @IBOutlet weak var fristNameSeparatorView: UIView!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameSeparatorView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailSeparatorView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordSeparatorView: UIView!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberSeparatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "Register")
        setupTextFieldsDelegate()
    }
    
    func setupTextFieldsDelegate() {
        fristNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        guard !fristNameTextField.text!.isEmpty else {
            presentSimpleAlert(viewController: self, title: "Register Failure",
                               message: "First name required!")
            return
        }
        guard !lastNameTextField.text!.isEmpty else {
            presentSimpleAlert(viewController: self, title: "Register Failure",
                               message: "Last name required!")
            return
        }
        guard !emailTextField.text!.isEmpty else {
            presentSimpleAlert(viewController: self, title: "Register Failure",
                               message: "Email required!")
            return
        }
        guard !passwordTextField.text!.isEmpty else {
            presentSimpleAlert(viewController: self, title: "Register Failure",
                               message: "Password required!")
            return
        }
        guard !phoneNumberTextField.text!.isEmpty else {
            presentSimpleAlert(viewController: self, title: "Register Failure",
                               message: "Phone number required!")
            return
        }
        
        registration()
        
    }
    
    
    func registration() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            [weak self] (authResult, error) in
            guard let _ = authResult?.user, error == nil else {
                self?.presentSimpleAlert(viewController: self!, title: "Register Failure", message: error!.localizedDescription)
                return
            }
            guard let currentUser = Auth.auth().currentUser else {
                print("Faild to load current user")
                return
            }
            let userId = currentUser.uid
            
            self?.createUserInfo(userId)
            self?.goToHomeVC()
        }
    }
    
    func goToHomeVC() {
        performSegue(withIdentifier: "goToMainApp", sender: self)
    }
    
    func createUserInfo(_ userId: String) {
        let newDocument = db.collection("registed-user").document(userId)
        newDocument.setData([
            "first-name":fristNameTextField.text!,
            "last-name":lastNameTextField.text!,
            "email":emailTextField.text!,
            "mobile-number":phoneNumberTextField.text!,
            "id":newDocument.documentID
        ])
    }
}
// MARK: Design
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fristNameTextField {
            setupDidSelectedValues(textField: fristNameTextField, label: fristNameLabel, separator: fristNameSeparatorView)
        } else if textField == lastNameTextField {
            setupDidSelectedValues(textField: lastNameTextField, label: lastNameLabel, separator: lastNameSeparatorView)
        } else if textField == emailTextField {
            setupDidSelectedValues(textField: emailTextField, label: emailLabel, separator: emailSeparatorView)
        } else if textField == passwordTextField {
            setupDidSelectedValues(textField: passwordTextField, label: passwordLabel, separator: passwordSeparatorView)
        } else if textField == phoneNumberTextField {
            setupDidSelectedValues(textField: phoneNumberTextField, label: phoneNumberLabel, separator: phoneNumberSeparatorView)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resetDidEndEditValues()
    }
    
    func setupDidSelectedValues(textField: UITextField, label: UILabel, separator: UIView) {
        textField.placeholder = ""
        label.isHidden = false
        separator.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
    }
    
    func resetDidEndEditValues() {
        let resetColor = #colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1)
        let isHidden = true
        fristNameSeparatorView.backgroundColor = resetColor
        lastNameSeparatorView.backgroundColor = resetColor
        emailSeparatorView.backgroundColor = resetColor
        passwordSeparatorView.backgroundColor = resetColor
        phoneNumberSeparatorView.backgroundColor = resetColor
        fristNameLabel.isHidden = isHidden
        lastNameLabel.isHidden = isHidden
        emailLabel.isHidden = isHidden
        passwordLabel.isHidden = isHidden
        phoneNumberLabel.isHidden = isHidden
        fristNameTextField.placeholder = "Frist name"
        lastNameTextField.placeholder = "Last name"
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        phoneNumberTextField.placeholder = "Phone number"
    }
}
