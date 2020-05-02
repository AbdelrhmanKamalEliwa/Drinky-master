//
//  DetailsViewController.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperCounter: UILabel!
    
    
    @IBOutlet weak var totalPrice: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        stepperCounter.text = String(Int(stepper.value))
    }
    
    
    @IBAction func addToCartPressed(_ sender: Any) {
    }
    
}
