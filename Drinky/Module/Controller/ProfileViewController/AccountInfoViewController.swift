//
//  AccountInfoViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class AccountInfoViewController: UIViewController {

    @IBOutlet weak var holderBackgroundView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Your Account Informations"
        holderBackgroundView.layer.cornerRadius = 10
    }

}
