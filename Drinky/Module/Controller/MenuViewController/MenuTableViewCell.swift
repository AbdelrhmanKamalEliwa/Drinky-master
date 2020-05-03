//
//  MenuTableViewCell.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundHolderView: UIView!
    @IBOutlet private weak var cupImage: UIImageView!
    @IBOutlet private weak var cupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundHolderView.layer.cornerRadius = 10
    }
    
    func displayData(drinkName: String, drinkImage: String?) {
        cupNameLabel.text = drinkName
        cupImage.image = UIImage(named: drinkImage ?? "error-image")
    }
    
}
