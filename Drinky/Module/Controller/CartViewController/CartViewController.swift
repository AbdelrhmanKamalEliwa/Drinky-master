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
    fileprivate var user: UserModel?
    fileprivate var delivery = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCartTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Cart"
        orders.removeAll()
        loadOrders()
    }
    
    func displayData() {
        if orders.count == 0 {
            delivery = 0
            let subTotal = calculateSubtotalTotalPrice()
            let total = calculateTotalPrice()
            delivaryCostLabel.text = String(delivery)
            subTotalLabel.text = String(subTotal)
            totalLabel.text = String(total)
        } else {
            delivery = 10
            let subTotal = calculateSubtotalTotalPrice()
            let total = calculateTotalPrice()
            delivaryCostLabel.text = String(delivery)
            subTotalLabel.text = String(subTotal)
            totalLabel.text = String(total)
        }
    }
    
    func registerCartTableView() {
        let cellNib = UINib(nibName: "CartItemCell", bundle: nil)
        cartTableView.register(cellNib, forCellReuseIdentifier: "CartItemCell")
    }
    
    @IBAction func checkOutPressed(_ sender: Any) {
        if orders.count == 0 {
            presentSimpleAlert(viewController: self, title: "No Orders Founded", message: "You don't have any orders in your Cart yet")
        } else {
            updateOrdersAfterChecckOut()
            presentSimpleAlert(viewController: self, title: "Success", message: "Your Order checked out")
        }
        
    }
    
    func calculateSubtotalTotalPrice() -> Int {
        var subTotal = 0
        for order in orders {
            subTotal += Int(order.price)!
        }
        return subTotal
    }
    
    func calculateTotalPrice() -> Int {
        var total = 0
        total = calculateSubtotalTotalPrice() + delivery
        return total
    }
    
    func getOrdersId() -> [String] {
        var ordersId: [String] = []
        for order in orders {
            ordersId.append(order.orderId)
        }
        return ordersId
    }
    
    
}

//MARK: - Table View Delegate and Data Source
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        cell.displayData(
            orders[indexPath.row].drinkName, orders[indexPath.row].size,
            orders[indexPath.row].price, orders[indexPath.row].quantity,
            orders[indexPath.row].drinkImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .normal, title:  "Remove", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.deleteOrder(self.orders[indexPath.row].orderId)
                self.orders.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.displayData()
                    tableView.reloadData()
                }
                success(true)
            })
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "trash")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.reloadData()
    }
    
}


//MARK: - Firestore Methods
extension CartViewController {
    
    func loadOrders() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid

        db.collection("orders")
            .whereField("user-id", isEqualTo: userId)
            .whereField("is-checked-out", isEqualTo: false).getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.orders.append(OrderModel(
                        drinkId: data["drink-id"] as! String,
                        orderId: data["order-id"] as! String,
                        userId: data["user-id"] as! String,
                        drinkName: data["drink-name"] as! String,
                        drinkImage: data["drink-image"] as! String,
                        size: data["size"] as! String,
                        suger: data["suger"] as! String,
                        quantity: data["quantity"] as! String,
                        price: data["total-price"] as! String,
                        isCheckedOut: data["is-checked-out"] as! Bool))
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.displayData()
                }
            }
        }
    }
    
    func deleteOrder(_ orderId: String) {
        db.collection("orders").document(orderId).delete { [weak self] (error) in
            if let error = error {
                self?.presentSimpleAlert(viewController: self!, title: "Failure", message: error.localizedDescription)
            } else {
                self?.presentSimpleAlert(viewController: self!, title: "Success", message: "Your order deleted successfuly")
            }
        }
    }
    
    func updateOrdersAfterChecckOut() {
        for order in orders {
            let newDocument = db.collection("orders").document(order.orderId)
            newDocument.updateData(["is-checked-out": true])
        }
        getUserInfo()
    }
    
    
    func fetchOrderHistory(_ address: String?) {
        guard let address = address else {
            presentSimpleAlert(viewController: self, title: "Check out error", message: "Please enter your address")
            return
        }
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        let ordersId: [String] = getOrdersId()
        let subTotal = String(calculateSubtotalTotalPrice())
        let total = String(calculateTotalPrice())
        let newDocument = db.collection("order-history").document()
        newDocument.setData([
            "order-history-id":newDocument.documentID,
            "user-id": userId,
            "orders-id": ordersId,
            "address": address,
            "delivery": String(delivery),
            "sub-total": subTotal,
            "total": total,
        ])
        orders = []
        delivaryCostLabel.text = "0.0"
        subTotalLabel.text = "0.0"
        totalLabel.text = "0.0"
        tableView.reloadData()
    }
    
    func getUserInfo() {
        
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        
        db.collection("registed-user").whereField("id", isEqualTo: userId).getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.user = UserModel(
                        id: data["id"] as! String,
                        firstName: data["first-name"] as! String,
                        lastName: data["last-name"] as! String,
                        email: data["email"] as! String,
                        mobileNumber: data["mobile-number"] as! String,
                        favoriteDrinks: data["favorite-drink"] as? [String],
                        address: data["address"] as? String)
                }
            }
            guard let user = self?.user else {
                print("can't load user info")
                return
            }
            guard let address = user.address else {
                print("can't load user address")
                return
            }
            self?.fetchOrderHistory(address)
        }
    }
}
