//
//  MenuTableViewCell.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var backgroundHolderView: UIView!
    @IBOutlet private weak var cupImage: UIImageView!
    @IBOutlet private weak var cupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundHolderView.layer.cornerRadius = 10
    }
    
    func displayData(drink: DrinkModel) {
        cupNameLabel.text = drink.name
        cupImage.image = UIImage(named: drink.image ?? "error-image")
    }
}
