//
//  ProfileViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileTableView: UITableView!
    
    var data = ["Your Account", "Favorites", "Order History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "")
        registerProfileTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Profile"
    }
    
    func registerProfileTableView() {
        let cellNib = UINib(nibName: "ProfileViewCell", bundle: nil)
        profileTableView.register(cellNib, forCellReuseIdentifier: "ProfileViewCell")
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as! ProfileViewCell
        cell.title = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountInfoVC = storyboard.instantiateViewController(identifier: "AccountInfoViewController") as! AccountInfoViewController
        let orderHistoryVC = storyboard.instantiateViewController(identifier: "OrderHistoryViewController") as! OrderHistoryViewController
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(accountInfoVC, animated: true)
        } else if indexPath.row == 2 {
            self.navigationController?.pushViewController(orderHistoryVC, animated: true)
        }
    }
}
