//
//  DrinksModel.swift
//  Drinky
//
//  Created by Awady on 4/30/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import Foundation

struct DrinkModel {
    let id: String
    let name: String
    let type: String
    let description: String
    let price: [Int]
    let rate: Int?
    let image: String?
}
