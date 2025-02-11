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
    
    @IBOutlet private weak var cupImage: UIImageView!
    @IBOutlet private weak var drinkName: UILabel!
    @IBOutlet private weak var drinkPrice: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var stepperCounter: UILabel!
    @IBOutlet private weak var totalPrice: UILabel!
    @IBOutlet private weak var drinkDescription: UILabel!
    @IBOutlet private weak var addToFavoriteButton: UIButton!
    
    fileprivate let db = Firestore.firestore()
    fileprivate var drink: DrinkModel?
    fileprivate var user: UserModel?
    fileprivate var price = 0
    fileprivate var size: String?
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
                button.setImage(UIImage(named: "CupSize0"), for: .normal)
                button.isSelected = false
            }
        }
        sender.setImage(UIImage(named: "CupSize1"), for: .normal)
        
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
    
    @IBAction private func chooseSugerPressed(_ sender: UIButton) {
        let allSugarTags = [4, 5, 6, 7]
        let currentSugarTag = sender.tag
        
        allSugarTags.filter { $0 != currentSugarTag }.forEach { tag in
            if let sugarButton = self.view.viewWithTag(tag) as? UIButton {
                sugarButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                sugarButton.isSelected = false
            }
        }
        sender.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.8745098039, blue: 0.368627451, alpha: 0.8965913955)
        sender.layer.cornerRadius = sender.frame.height/2
        
        if sender.tag == 4 {
            suger = 0
        } else if sender.tag == 5 {
            suger = 1
        } else if sender.tag == 6 {
            suger = 2
        } else if sender.tag == 7 {
            suger = 3
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction private func stepperAction(_ sender: Any) {
        stepperCounter.text = String(Int(stepper.value))
        displayTotalPrice()
    }
    
    private func displayTotalPrice() {
        totalPrice.text = "\(price * Int(stepper.value)) EGP"
    }
    
    @IBAction private func addToFavoriteTapped(_ sender: UIButton) {
        if sender.tintColor == .red {
            sender.tintColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            removeFromFavorite()
        } else {
            sender.tintColor = .red
            addToFavorite()
        }
        
    }
    
    @IBAction private func addToCartPressed(_ sender: Any) {
        guard let safeSize = size else {
            presentSimpleAlert(viewController: self, title: "Failed", message: "Please select size")
            return
        }
        
        fetchOrder(safeSize, String(suger), String(Int(stepper.value)), String(price * Int(stepper.value)))
        let alert = UIAlertController(title: "Success", message: "Your order added to Cart", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func displayData(_ drinkImage: String?, _ name: String, _ description: String, _ price: [Int]) {
        cupImage.layer.cornerRadius = 10
        cupImage.image = UIImage(named: drinkImage ?? "")
        drinkName.text = name
        drinkDescription.text = description
        drinkPrice.text = "\(price[0]) EGP"
    }
 
}


//MARK: - Firestrore Methods
extension DetailsViewController {
    private func getDrink(drindId: String) {
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
                self?.checkForFavorite()
            }
        }
    }
    
    private func fetchOrder(_ size: String, _ suger: String, _ quantity: String, _ totalprice: String) {
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
            "total-price": totalprice,
            "is-checked-out": false
        ])
    }
    
    
    private func getFavoriteDrinks(userId: String) {
        db.collection("registed-user").whereField("id", isEqualTo: userId).getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.user = UserModel(
                        id: data["id"] as! String,
                        firstName: data["first-name"] as! String,
                        lastName: data["last-name"] as! String,
                        email: data["email"] as! String,
                        mobileNumber: data["mobile-number"] as! String,
                        favoriteDrinks: data["favorite-drink"] as? [String],
                        address: data["address"] as? String)

                }
            }
            
            guard let user = self?.user else {
                print("can't load user")
                return
            }
            
            guard let favoriteDrinks = user.favoriteDrinks else {
                print("there is no favorite drinks")
                return
            }

            if favoriteDrinks.contains((self?.drink!.id)!) {
                self?.addToFavoriteButton.tintColor = .red
            } else {
                self?.addToFavoriteButton.tintColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            }
        }
    }
    
    private func removeFromFavorite() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        
        guard let drink = drink else {
            print("Faild to load drink id")
            return
        }
        
        let newDocument = db.collection("registed-user").document(userId)
        newDocument.updateData(["favorite-drink": FieldValue.arrayRemove([drink.id])])
    }
    
    private func checkForFavorite() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        getFavoriteDrinks(userId: userId)
    }
    
    private func addToFavorite() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        
        guard let drink = drink else {
            print("Faild to load drink id")
            return
        }
        
        let newDocument = db.collection("registed-user").document(userId)
        newDocument.updateData(["favorite-drink": FieldValue.arrayUnion([drink.id])])
    }
}

