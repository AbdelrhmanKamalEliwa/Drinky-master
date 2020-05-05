//
//  OrderModel.swift
//  Drinky
//
//  Created by Abdelrhman Eliwa on 5/3/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import Foundation

struct OrderModel {
    let drinkId: String
    let orderId: String
    let userId: String
    let drinkName: String
    let drinkImage: String?
    let size: String
    let suger: String
    let quantity: String
    let price: String
    let isCheckedOut: Bool
}
