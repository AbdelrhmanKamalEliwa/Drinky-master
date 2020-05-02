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
        setupNavBarForTabBar(title: "Menu")
        setupTabAttributes()
    }
    
    func setupTabAttributes() {
        self.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func changeSelectedTabColor() {
        if self.selectedIndex == 0 {
            self.tabBar.tintColor = #colorLiteral(red: 1, green: 0.9207810495, blue: 0.8098561175, alpha: 1)
        } else if self.selectedIndex == 1 {
            self.tabBar.tintColor = #colorLiteral(red: 1, green: 0.9133522299, blue: 0.9680454037, alpha: 1)
        } else if self.selectedIndex == 2 {
            self.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
            
    }
    
}
