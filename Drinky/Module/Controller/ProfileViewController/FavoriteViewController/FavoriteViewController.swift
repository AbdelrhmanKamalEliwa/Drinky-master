//
//  FavoriteViewController.swift
//  Drinky
//
//  Created by Awady on 5/4/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FavoriteViewController: UIViewController {
    
    fileprivate let db = Firestore.firestore()
    fileprivate var drinks: [DrinkModel] = []
    fileprivate var user: UserModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerTableView()
        getUserInfo()
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK: - Table View Delegate and Data Source
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableCell
        cell.displayData(drinkName: drinks[indexPath.row].name, drinkImage: drinks[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.drinkId = drinks[indexPath.row].id
        self.navigationController?.pushViewController(detailsViewController , animated: true)
    }
    
    func registerTableView() {
        let nib = UINib(nibName: "FavoriteTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavoriteTableCell")
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Remove", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.removeFromFavorite(self.drinks[indexPath.row].id)
            self.drinks.remove(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            success(true)
        })
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

//MARK: - Firestore Methods
extension FavoriteViewController {
    
    func getUserInfo() {

        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid

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
            self?.fetchFavoriteDrinks(favoriteDrinks)
        }
    }



    func fetchFavoriteDrinks(_ favoriteDrinks: [String]?) {

        guard let favoriteDrinks = favoriteDrinks else {
            print("can't load user")
            return
        }

        for drink in favoriteDrinks {
            db.collection("drinks").whereField("id", isEqualTo: drink).getDocuments {
                [weak self] (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        self?.drinks.append(DrinkModel(
                            id: data["id"] as! String,
                            name: data["name"] as! String,
                            type: data["type"] as! String,
                            description: data["description"] as! String,
                            price: data["price"] as! [Int],
                            rate: data["description"] as? Int,
                            image: data["image"] as? String))
                    }
                    print(self!.drinks)
                    self?.tableView.reloadData()
                }
            }

        }
    }
    
    func removeFromFavorite(_ drinkId: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Faild to load current user")
            return
        }
        let userId = currentUser.uid
        let newDocument = db.collection("registed-user").document(userId)
        newDocument.updateData(["favorite-drink": FieldValue.arrayRemove([drinkId])])
    }
    
}
