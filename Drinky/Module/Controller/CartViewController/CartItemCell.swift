//
//  CartItemCell.swift
//  Drinky
//
//  Created by Awady on 5/3/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var cupImage: UIImageView!
    @IBOutlet private weak var cupNameLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    func displayData(_ order: OrderModel) {
        cupNameLabel.text = order.drinkName
        sizeLabel.text = order.size
        priceLabel.text = order.price
        quantityLabel.text = order.quantity
        cupImage.image = UIImage(named: order.drinkImage ?? "error-image")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.clear
    }
}
