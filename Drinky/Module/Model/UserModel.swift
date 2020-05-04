//
//  UserModel.swift
//  Drinky
//
//  Created by Abdelrhman Eliwa on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import Foundation

struct UserModel {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let mobileNumber: String
    let favoriteDrinks: [String]?
    let address: String?
}
