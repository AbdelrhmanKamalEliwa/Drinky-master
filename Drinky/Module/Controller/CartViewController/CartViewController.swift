//
//  CartViewController.swift
//  Drinky
//
//  Created by Awady on 5/3/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var delivaryCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var cartItems = ["Tea","Cofee","Laite","Cuputchino","Hot Choclate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCartTableView()
        setupTitleNavItem(navTitle: "Cart")
    }
    
    func registerCartTableView() {
        let cellNib = UINib(nibName: "CartItemCell", bundle: nil)
        cartTableView.register(cellNib, forCellReuseIdentifier: "CartItemCell")
    }
    
    @IBAction func checkoutPressed(_ sender: Any) {
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        cell.name = cartItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
