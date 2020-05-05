//
//  HistoryTableViewCell.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var holderBackgroundView: UIView!
    @IBOutlet weak var orderListTableView: UITableView!
    @IBOutlet private weak var orderLabel: UILabel!
//    @IBOutlet weak var tableViewHieghtConstraint: NSLayoutConstraint!
    
    var order: String! {
        didSet {
            orderLabel.text = order
        }
    }
    
    var orderList = ["Ahmed", "Mohamed", "eliwa", "Adel"]
    override func awakeFromNib() {
        super.awakeFromNib()
        holderBackgroundView.layer.cornerRadius = 10
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        registerOrderListCell()
    }
    
    func registerOrderListCell() {
        let CellNib = UINib(nibName: "OrderListTableCell", bundle: nil)
        orderListTableView.register(CellNib, forCellReuseIdentifier: "OrderListTableCell")
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

extension HistoryTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableCell", for: indexPath) as! OrderListTableCell
        cell.name = orderList[indexPath.row]
//        self.tableViewHieghtConstraint.constant = tableView.contentSize.height
        return cell
    }
}
