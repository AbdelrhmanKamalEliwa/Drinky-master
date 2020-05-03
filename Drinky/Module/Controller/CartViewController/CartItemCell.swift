//
//  CartItemCell.swift
//  Drinky
//
//  Created by Awady on 5/3/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var cupNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var name: String! {
        didSet {
            cupNameLabel.text = name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.clear
    }
}
