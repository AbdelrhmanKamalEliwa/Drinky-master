//
//  CartViewController.swift
//  Drinky
//
//  Created by Awady on 5/3/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var delivaryCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    let db = Firestore.firestore()
    fileprivate var orders: [OrderModel] = []
    fileprivate var drink: DrinkModel?
    
//    var cartItems = ["Tea","Cofee","Laite","Cuputchino","Hot Choclate"]
    
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
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
//        cell.displayData(<#T##name: String##String#>, <#T##size: String##String#>, <#T##price: String##String#>, <#T##quantity: String##String#>, <#T##image: String?##String?#>)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}


//MARK: - Firestore Methods
//extension CartViewController {
//    func loadOrders() {
//        
//        guard let currentUser = Auth.auth().currentUser else {
//            print("Faild to load current user")
//            return
//        }
//        let userId = currentUser.uid
//        
//        db.collection("orders").whereField("user-id", isEqualTo: userId).getDocuments {
//            [weak self] (snapshot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            if let snapshot = snapshot {
//                for document in snapshot.documents {
//                    let data = document.data()
//                    self?.orders.append(OrderModel(
//                        drinkId: data["drink-id"] as! String,
//                        orderId: data["order-id"] as! String,
//                        userId: data["user-id"] as! String,
//                        size: data["size"] as! String,
//                        suger: data["suger"] as! String,
//                        quantity: data["quantity"] as! String,
//                        price: data["total-price"] as! String))
//                }
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//                
//            }
//        }
//    }
//    
//    db.collection("drinks").whereField("id", isEqualTo: ).getDocuments {
//        [weak self] (snapshot, error) in
//        if let error = error {
//            print(error.localizedDescription)
//        }
//        if let snapshot = snapshot {
//            for document in snapshot.documents {
//                let data = document.data()
//                self?.orders.append(OrderModel(
//                    drinkId: data["drink-id"] as! String,
//                    orderId: data["order-id"] as! String,
//                    userId: data["user-id"] as! String,
//                    size: data["size"] as! String,
//                    suger: data["suger"] as! String,
//                    quantity: data["quantity"] as! String,
//                    price: data["total-price"] as! String))
//            }
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//            
//        }
//    }
//}
