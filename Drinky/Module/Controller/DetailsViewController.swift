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
    fileprivate var size = ""
    fileprivate var suger = 0
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
            if drink!.price.count == 0 {
                presentSimpleAlert(viewController: self, title: "Sorry", message: "This size is not available now.")
                return
            }
            drinkPrice.text = "\(drink!.price[0]) EGP"
            price = drink!.price[0]
            size = "S"
            
        } else if sender.tag == 2 {
            if drink!.price.count == 1 {
                presentSimpleAlert(viewController: self, title: "Sorry", message: "This size is not available now.")
                return
            }
            drinkPrice.text = "\(drink!.price[1]) EGP"
            price = drink!.price[1]
            size = "M"
            
        } else if sender.tag == 3 {
            if drink!.price.count == 2 || drink!.price.count == 1 {
                presentSimpleAlert(viewController: self, title: "Sorry", message: "This size is not available now.")
                return
            }
            drinkPrice.text = "\(drink!.price[2]) EGP"
            price = drink!.price[2]
            size = "L"
        }
        
        displayTotalPrice()
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func chooseSugerPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            suger = 0
        } else if sender.tag == 2 {
            suger = 1
        } else if sender.tag == 3 {
            suger = 2
        } else if sender.tag == 4 {
            suger = 3
        }
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
        fetchOrder(size, String(suger), String(stepper.value), String(price * Int(stepper.value)))
        let alert = UIAlertController(title: "Success", message: "Your order added to Cart", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
    
    
    func fetchOrder(_ size: String, _ suger: String, _ quantity: String, _ totalprice: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        
        guard let drink = drink else {
            print("Faild to load drink id")
            return
        }
        
        guard let image = drink.image else {
            return
        }
        
        let newDocument = db.collection("orders").document()
        newDocument.setData([
            "user-id": userId,
            "drink-id":drink.id,
            "order-id": newDocument.documentID,
            "drink-name": drink.name,
            "drink-image": image,
            "size": size,
            "suger": suger,
            "quantity": quantity,
            "total-price": totalprice
        ])

    }
    
}



