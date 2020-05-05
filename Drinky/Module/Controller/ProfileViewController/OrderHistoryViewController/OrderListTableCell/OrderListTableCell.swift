//
//  OrderListTableCell.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class OrderListTableCell: UITableViewCell {
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
        
    func displayData(_ order: OrderModel) {
        nameLabel.text = order.drinkName
        sizeLabel.text = order.size
        priceLabel.text = order.price
        quantityLabel.text = order.quantity
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
