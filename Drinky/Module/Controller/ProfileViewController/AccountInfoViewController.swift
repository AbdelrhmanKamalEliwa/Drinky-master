//
//  AccountInfoViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountInfoViewController: UIViewController {

    @IBOutlet weak var holderBackgroundView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    fileprivate let db = Firestore.firestore()
    fileprivate var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "Account Informations")
        holderBackgroundView.layer.cornerRadius = 10
        getUserInfo()
    }
    
    func displayData(_ fullName: String, _ email: String, _ address: String, _ phoneNumber: String) {
        userNameLabel.text = fullName
        emailLabel.text = email
        addressLabel.text = address
        phoneNumberLabel.text = phoneNumber
    }
}

//MARK: - Firestore Methods
extension AccountInfoViewController {
    
    func getUserInfo() {
        
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        
        db.collection("registed-user").whereField("id", isEqualTo: userId).getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.user = UserModel(
                        id: data["id"] as! String,
                        firstName: data["first-name"] as! String,
                        lastName: data["last-name"] as! String,
                        email: data["email"] as! String,
                        mobileNumber: data["mobile-number"] as! String,
                        favoriteDrinks: data["favorite-drink"] as? [String],
                        address: data["address"] as? String)
                }
            }
            guard let user = self?.user else {
                print("can't load user info")
                return
            }
            let fullName = user.firstName + " " + user.lastName
            self?.displayData(fullName, user.email, user.address ?? "Address not founded", user.mobileNumber)
            
        }
    }
}
