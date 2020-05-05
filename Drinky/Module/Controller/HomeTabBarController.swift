//
//  HomeTabBarController.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarForTabBar(title: "Home")
        setupTabAttributes()
    }
    
    private func setupTabAttributes() {
        self.tabBar.tintColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        self.tabBar.barTintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
}
