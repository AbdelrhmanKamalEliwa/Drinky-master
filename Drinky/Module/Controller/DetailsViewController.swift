//
//  DetailsViewController.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperCounter: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var drinkDescription: UILabel!
    
    fileprivate let db = Firestore.firestore()
    fileprivate var drink: DrinkModel?
    fileprivate var price = 0
    var drinkId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "Preferences")
        getDrink(drindId: drinkId)
    }
    
    @IBAction private func chooseCupSizePressed(_ sender: UIButton) {
        let allButtonTags = [1, 2, 3]
        let currentButtonTag = sender.tag
        
        allButtonTags.filter { $0 != currentButtonTag }.forEach { tag in
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.setImage(UIImage(named: "123"), for: .normal)
                button.isSelected = false
            }
        }
        sender.setImage(UIImage(named: "321"), for: .normal)
        if sender.tag == 1 {
            drinkPrice.text = "\(drink!.price[0]) EGP"
            price = drink!.price[0]
        } else if sender.tag == 2 {
            drinkPrice.text = "\(drink!.price[1]) EGP"
            price = drink!.price[1]
        } else if sender.tag == 3 {
            drinkPrice.text = "\(drink!.price[2]) EGP"
            price = drink!.price[2]
        }
        displayTotalPrice()
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func chooseSugerPressed(_ sender: UIButton) {
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        stepperCounter.text = String(Int(stepper.value))
        displayTotalPrice()
    }
    
    func displayTotalPrice() {
        totalPrice.text = "\(price * Int(stepper.value)) EGP"
    }
    
    @IBAction func addToFavoriteTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {sender.tintColor = .red} else {sender.tintColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)}
        
    }
    
    @IBAction func addToCartPressed(_ sender: Any) {
    }
    
    func displayData(_ drinkImage: String?, _ name: String, _ description: String, _ price: [Int]) {
        cupImage.layer.cornerRadius = 10
        cupImage.image = UIImage(named: drinkImage ?? "")
        drinkName.text = name
        drinkDescription.text = description
        drinkPrice.text = "\(price[0]) EGP"
    }
    
    func getDrink(drindId: String) {
        db.collection("drinks").whereField("id", isEqualTo: drindId).getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    self?.drink = DrinkModel(
                    id: data["id"] as! String,
                    name: data["name"] as! String,
                    type: data["type"] as! String,
                    description: data["description"] as! String,
                    price: data["price"] as! [Int],
                    rate: data["rate"] as? Int,
                    image: data["image"] as? String)
                }
                DispatchQueue.main.async {
                    self?.displayData(self?.drink?.image,
                                      (self?.drink!.name)!,
                                      (self?.drink!.description)!,
                                      (self?.drink!.price)!)
                }
            }
        }
    }
}
