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
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var emailSeparetorView: UIView!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordSeparatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewDisplay()
    }
    
    func setupViewDisplay() {
        setupNavigationBar(title: "Login")
        setupTextFieldsDelegate()
    }
    
    private func setupTextFieldsDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction private func loginPressed(_ sender: Any) {
        guard  !emailTextField.text!.isEmpty, !passwordTextField.text!.isEmpty
            else {
                presentSimpleAlert(viewController: self, title: "Fileds are blank!", message: "All fileds must filled in!")
                return
        }
        login()
    }
    
    @IBAction private func forgetPasswordPressed(_ sender: Any) {
    }
    
    
    private func login() {
        Auth.auth().signIn(withEmail: emailTextField.text! , password: passwordTextField.text!) {
            [weak self] (authResult, error) in
            guard let _ = authResult, error == nil else {
                self?.presentSimpleAlert(viewController: self!, title: "Login Failure", message: error!.localizedDescription)
                return
            }
            self?.goToHomeVC()
        }
    }
    
    private func goToHomeVC() {
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
    
    private func resetDidEndEditValues() {
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
