//
//  ProfileScreenModel.swift
//  Drinky
//
//  Created by Abdelrhman Eliwa on 5/5/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import Foundation

struct ProfileScreenModel {
    let title: String
    let image: String
}


class ProfileScreenManager {
    
    static let shared = ProfileScreenManager()
    private var data: [ProfileScreenModel] = []
    
    private func fillData() {
        data.removeAll()
        data.append(ProfileScreenModel(title: "Your Account", image: "person.circle.fill"))
        data.append(ProfileScreenModel(title: "Favorite Drinks", image: "suit.heart.fill"))
        data.append(ProfileScreenModel(title: "Orders History", image: "clock.fill"))
        data.append(ProfileScreenModel(title: "Contact Us", image: "phone.circle.fill"))
        data.append(ProfileScreenModel(title: "About Us", image: "exclamationmark.circle.fill"))
        data.append(ProfileScreenModel(title: "Log Out", image: "arrowshape.turn.up.left.circle.fill"))
    }
    
    func getData() -> [ProfileScreenModel] {
        fillData()
        return data
    }
}
