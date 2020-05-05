//
//  OrderHistoryViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    @IBOutlet weak var ordersTableView: UITableView!
    
    var data = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerOrderListCell()
    }
    
    func registerOrderListCell() {
        let CellNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        ordersTableView.register(CellNib, forCellReuseIdentifier: "HistoryTableViewCell")
    }
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.order = data[indexPath.row]
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
