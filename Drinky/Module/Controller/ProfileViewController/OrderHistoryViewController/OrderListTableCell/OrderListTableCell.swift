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
    
    func displayData(_ name: String, _ size: String, _ price: String, _ quantity: String) {
        nameLabel.text = name
        sizeLabel.text = size
        priceLabel.text = price
        quantityLabel.text = quantity
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
