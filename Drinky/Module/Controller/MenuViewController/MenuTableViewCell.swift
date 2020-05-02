//
//  MenuTableViewCell.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var cupImage: UIImageView!
    @IBOutlet private weak var cupNameLabel: UILabel!
    
//    var cupName: String! {
//        didSet {
//            cupNameLabel.text = cupName
//        }
//    }
    
    func displayData(drinkName: String, drinkImage: String?) {
        cupNameLabel.text = drinkName
        cupImage.image = UIImage(named: drinkImage ?? "error-image")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
