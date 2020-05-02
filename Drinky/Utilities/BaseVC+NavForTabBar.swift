//
//  NavigationAttributes.swift
//  Feshar
//
//  Created by Awady on 4/1/20.
//  Copyright © 2020 Awady. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationBar(title: String) {
        setupTitleNavItem(navTitle: title)
        setupBackButtonNavItem()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupTitleNavItem(navTitle: String) {
        let title = navTitle
        navigationItem.title = title
    }
    
    func setupBackButtonNavItem() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.tintColor = #colorLiteral(red: 0.1261958638, green: 0.1237214351, blue: 0.1237214351, alpha: 1)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    public func presentSimpleAlert(viewController: UIViewController, title: String, message: String, completion: @escaping(_ done: Bool) -> Void = {_ in}) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion(true)
        }
        
        alert.addAction(dismissAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
//    func showAlert(title: String, message: String, okTitle: String = "ok", okHandler: ((UIAlertAction)->Void)? = nil)
//    {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: okHandler))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func setupWishlistNavItem() {
//        if UIViewController.self != WatchlistViewController.self {
//        let wishlistButton = UIButton(type: .custom)
//        wishlistButton.setImage(UIImage(systemName: "wand.and.stars")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        wishlistButton.tintColor = #colorLiteral(red: 0.1843137255, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
//        wishlistButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        wishlistButton.addTarget(self, action: #selector(clickWishList), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: wishlistButton)
//        }
//    }
    
//    @objc func clickWishList(){
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        if let WatchlistViewController = mainStoryboard.instantiateViewController(withIdentifier: "WatchlistViewController") as? WatchlistViewController {
//            WatchlistViewController.modalPresentationStyle = .automatic
//            self.navigationController?.pushViewController(WatchlistViewController, animated: true)
//        }
//    }
    
    @objc func clickBack(){
        navigationController?.modalPresentationStyle = .automatic
        navigationController?.popViewController(animated: true)
    }
}

extension UITabBarController {
    func setupNavBarForTabBar(title: String) {
//        setupNavigationBar(title: title)
        setupTitleNavItem(navTitle: title)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setTabBarItemColor(color: UIColor) {
        tabBar.tintColor = color
    }
}
