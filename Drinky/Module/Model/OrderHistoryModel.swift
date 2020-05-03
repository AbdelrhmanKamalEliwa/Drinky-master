//
//  OrderHistoryModel.swift
//  Drinky
//
//  Created by Abdelrhman Eliwa on 5/3/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import Foundation

struct OrderHistoryModel {
    let orderHistoryId: String
    let userId: String
    let ordersId: [String]
    let address: String
    let deliveryPrice: String
    let subTotalPrice: String
    let totalPrice: String
}
