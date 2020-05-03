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
    
//    var name: String! {
//        didSet {
//            cupNameLabel.text = name
//        }
//    }
    
    func displayData(_ name: String, _ size: String, _ price: String, _ quantity: String, _ image: String?) {
        cupNameLabel.text = name
        sizeLabel.text = size
        priceLabel.text = price
        quantityLabel.text = quantity
        cupImage.image = UIImage(named: image ?? "error-image")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.clear
    }
}
