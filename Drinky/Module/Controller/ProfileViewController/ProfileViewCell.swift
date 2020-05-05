//
//  ProfileViewCell.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var titleIconImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    func displayData(_ title: String, _ image: String) {
        titleLabel.text = title
        titleIconImage.image = UIImage(systemName: image)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 10
    }
    
}
