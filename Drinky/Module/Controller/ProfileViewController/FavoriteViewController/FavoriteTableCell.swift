//
//  FavoriteTableCell.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class FavoriteTableCell: UITableViewCell {

    @IBOutlet private weak var drinkNameLabel: UILabel!
    @IBOutlet private weak var drinkImageView: UIImageView!
    @IBOutlet private weak var holderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        holderView.layer.cornerRadius = 10
    }
    
    func displayData(_ drink: DrinkModel) {
        drinkNameLabel.text = drink.name
        drinkImageView.image = UIImage(named: drink.image ?? "error-image")
    }
    
}
