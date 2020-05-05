//
//  OrderHistoryViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    fileprivate let db = Firestore.firestore()
    fileprivate var orderHistory: [OrderHistoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerOrderListCell()
        loadOrders()
    }
    
    func registerOrderListCell() {
        let cellNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        ordersTableView.register(cellNib, forCellReuseIdentifier: "HistoryTableViewCell")
    }
}

//MARK: - Table View Delegate and Data Source
extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.orderName = orderHistory[indexPath.row].orderHistoryId
        cell.fillOrdersData(orderHistory[indexPath.row].ordersId)
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: - Firestore Methods
extension OrderHistoryViewController {
    func loadOrders() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid

        db.collection("order-history")
            .whereField("user-id", isEqualTo: userId).getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.orderHistory.append(OrderHistoryModel(
                        orderHistoryId: data["order-history-id"] as! String,
                        userId: data["user-id"] as! String,
                        ordersId: data["orders-id"] as! [String],
                        address: data["address"] as! String,
                        deliveryPrice: data["delivery"] as! String,
                        subTotalPrice: data["sub-total"] as! String,
                        totalPrice: data["total"] as! String))
                }
                DispatchQueue.main.async {
                    self?.ordersTableView.reloadData()
                }
            }
        }
    }
    
}
