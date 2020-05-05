//
//  HistoryTableViewCell.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var holderBackgroundView: UIView!
    @IBOutlet private weak var orderListTableView: UITableView!
    @IBOutlet private weak var orderLabel: UILabel!
    
    fileprivate let db = Firestore.firestore()
    fileprivate var orders: [OrderModel] = []
    var ordersId: [String] = []
    var orderName: String! {
        didSet {
            orderLabel.text = orderName
        }
    }
    
    var orderList = ["Ahmed", "Mohamed", "eliwa", "Adel"]
    override func awakeFromNib() {
        super.awakeFromNib()
        holderBackgroundView.layer.cornerRadius = 10
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        registerOrderListCell()
        
//        print(ordersId)
    }
    
    
    func registerOrderListCell() {
        let CellNib = UINib(nibName: "OrderListTableCell", bundle: nil)
        orderListTableView.register(CellNib, forCellReuseIdentifier: "OrderListTableCell")
    }
    
    func fillOrdersData(_ data: [String]) {
        ordersId = data
        loadOrderHistoryData()
        orderListTableView.reloadData()
    }
    
    @IBAction func showAndHideOrderDetails(_ sender: UIButton) {
        if orderListTableView.isHidden {
            sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            orderListTableView.isHidden = false
            orderListTableView.reloadData()
        } else {
            sender.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            orderListTableView.isHidden = true
            orderListTableView.reloadData()
        }
    }
    
    
}


//MARK: - Table View Delegate and Data Source
extension HistoryTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableCell", for: indexPath) as! OrderListTableCell
        cell.displayData(orders[indexPath.row].drinkName, orders[indexPath.row].size,
                         orders[indexPath.row].price, orders[indexPath.row].quantity)
        return cell
    }
}


//MARK: - Firestore Methods
extension HistoryTableViewCell {
    
    func loadOrderHistoryData() {
        for orderId in ordersId {
            loadOrdersData(orderId)
        }
    }
    
    func loadOrdersData(_ orderId: String) {
        db.collection("orders")
            .whereField("order-id", isEqualTo: orderId)
            .whereField("is-checked-out", isEqualTo: true)
            .getDocuments {
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
                    print(self!.orders)
                    DispatchQueue.main.async {
                        self?.orderListTableView.reloadData()
                    }
                }
        }
    }
    
    
}
