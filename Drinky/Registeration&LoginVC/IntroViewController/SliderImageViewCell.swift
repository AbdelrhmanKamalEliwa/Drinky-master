//
//  SliderImageViewCell.swift
//  Drinky
//
//  Created by Awady on 4/29/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class SliderImageViewCell: UICollectionViewCell {

    @IBOutlet weak var sliderImageCell: UIImageView!
    
    var imageCell: UIImage! {
        didSet {
            sliderImageCell.image = imageCell
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
