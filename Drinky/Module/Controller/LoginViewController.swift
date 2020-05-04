//
//  LoginViewController.swift
//  Drinky
//
//  Created by Awady on 4/30/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailSeparetorView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordSeparatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "Login")
        setupTextFieldsDelegate()
    }
    
    func setupTextFieldsDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard  !emailTextField.text!.isEmpty, !passwordTextField.text!.isEmpty
            else {
                presentSimpleAlert(viewController: self, title: "Fileds are blank!", message: "All fileds must filled in!")
                return
        }
        login()
    }
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
    }
    
    
    func login() {
        Auth.auth().signIn(withEmail: emailTextField.text! , password: passwordTextField.text!) {
            [weak self] (authResult, error) in
            guard let _ = authResult, error == nil else {
                self?.presentSimpleAlert(viewController: self!, title: "Login Failure", message: error!.localizedDescription)
                return
            }
            self?.goToHomeVC()
        }
    }
    
    func goToHomeVC() {
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
}

// MARK: Design
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            setupDidSelectedValues(textField: emailTextField, label: emailLabel, separator: emailSeparetorView)
        } else if textField == passwordTextField {
            setupDidSelectedValues(textField: passwordTextField, label: passwordLabel, separator: passwordSeparatorView)
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
        emailSeparetorView.backgroundColor = resetColor
        passwordSeparatorView.backgroundColor = resetColor
        emailLabel.isHidden = isHidden
        passwordLabel.isHidden = isHidden
        emailTextField.placeholder = "Frist name"
        passwordTextField.placeholder = "Password"
    }
}
