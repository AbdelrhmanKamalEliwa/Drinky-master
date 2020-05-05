//
//  ProfileViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet private weak var profileTableView: UITableView!
    
    private var data = ProfileScreenManager.shared.getData()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "")
        registerProfileTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Profile"
    }
}


//MARK: - Table View Delegate and Data Source
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as! ProfileViewCell
        let title = data[indexPath.row].title
        let image = data[indexPath.row].image
        cell.displayData(title, image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountInfoVC = storyboard.instantiateViewController(identifier: "AccountInfoViewController") as! AccountInfoViewController
        let favoriteVC = storyboard.instantiateViewController(identifier: "FavoriteViewController") as! FavoriteViewController
        let orderHistoryVC = storyboard.instantiateViewController(identifier: "OrderHistoryViewController") as! OrderHistoryViewController
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(accountInfoVC, animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(favoriteVC, animated: true)
        } else if indexPath.row == 2 {
            self.navigationController?.pushViewController(orderHistoryVC, animated: true)
        } else if indexPath.row == 3 {
            self.presentSimpleAlert(viewController: self, title: "Contact Us", message: "You can contact us on 01009494758")
        } else if indexPath.row == 4 {
            let aboutUsVC = AboutUsViewController()
            aboutUsVC.modalPresentationStyle = .custom
            aboutUsVC.modalTransitionStyle = .crossDissolve
            present(aboutUsVC, animated: true, completion: nil)
        } else if indexPath.row == 5 {
            logout()
        }
    }
    
    private func registerProfileTableView() {
        let cellNib = UINib(nibName: "ProfileViewCell", bundle: nil)
        profileTableView.register(cellNib, forCellReuseIdentifier: "ProfileViewCell")
    }
}


//MARK: - Firebase Methods
extension ProfileViewController {
    private func logout() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            
        } catch let error {
            self.presentSimpleAlert(viewController: self, title: "Log Out Failure", message: "Something wrong happens while Log Out, please try again")
            print(error)
        }
    }
}
