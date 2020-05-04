//
//  MenuViewController.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var menuSearchBar: UISearchBar!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    fileprivate var selectedSegment = 0
    
    fileprivate let db = Firestore.firestore()
    fileprivate var searching = false
    fileprivate var freshDrinks: [DrinkModel] = []
    fileprivate var hotDrinks: [DrinkModel] = []
    fileprivate var softDrinks: [DrinkModel] = []
    fileprivate var waterDrinks: [DrinkModel] = []
    fileprivate var filteredDrinks: [DrinkModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.title = "Menu"
        registerMenuTableView()
        categoriesSegmentedControl.selectedSegmentIndex = 0
        sutupSegmentControlAttributes()
        setupSearchBar()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Menu"
//        self.tabBarController?.navigationItem.leftBarButtonItem = settingsButton //This is the IBOutlet variable that you previously added
    }
    
    func loadData() {
        loadFreshDrinks()
        loadHotDrinks()
        loadSoftDrinks()
        loadWaterDrinks()
        menuTableView.reloadData()
    }
    
    func registerMenuTableView() {
        let menuNib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuNib, forCellReuseIdentifier: "MenuTableViewCell")
    }
    
    func setupSearchBar() {
        menuSearchBar.searchBarStyle = .minimal
        menuSearchBar.searchTextField.delegate = self
        menuSearchBar.delegate = self
    }
    
    @IBAction func handleSelectedSegmentControl(_ sender: Any) {
        switch categoriesSegmentedControl.selectedSegmentIndex {
        case 0: selectedSegment = 0
        case 1: selectedSegment = 1
        case 2: selectedSegment = 2
        default: selectedSegment = 3
        }
        sutupSegmentControlAttributes()
        menuTableView.reloadData()
    }
    
    func sutupSegmentControlAttributes() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        let selectedTextAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        categoriesSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        categoriesSegmentedControl.setTitleTextAttributes(selectedTextAttribute, for: .selected)
    }
    
    func numberOfRowsOfTableView() -> Int {
        if selectedSegment == 0 {
            return freshDrinks.count
        } else if selectedSegment == 1 {
            return hotDrinks.count
        } else if selectedSegment == 2 {
            return softDrinks.count
        } else {
            return waterDrinks.count
        }
    }
}

//MARK: - Table View Delegate and Data Source
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredDrinks.count
        } else {
            return numberOfRowsOfTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        if searching {
            cell.displayData(drinkName: filteredDrinks[indexPath.row].name,
                             drinkImage: filteredDrinks[indexPath.row].image)
            return cell
            
        } else {
            
            if selectedSegment == 0 {
                cell.displayData(drinkName: freshDrinks[indexPath.row].name,
                                 drinkImage: freshDrinks[indexPath.row].image)
            } else if selectedSegment == 1 {
                cell.displayData(drinkName: hotDrinks[indexPath.row].name,
                                 drinkImage: hotDrinks[indexPath.row].image)
            } else if selectedSegment == 2 {
                cell.displayData(drinkName: softDrinks[indexPath.row].name,
                                 drinkImage: softDrinks[indexPath.row].image)
            } else if selectedSegment == 3 {
                cell.displayData(drinkName: waterDrinks[indexPath.row].name,
                                 drinkImage: waterDrinks[indexPath.row].image)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if menuTableView.panGestureRecognizer.translation(in: self.view).y < 0 {
            self.menuSearchBar.isHidden = true
            self.categoriesSegmentedControl.isHidden = true
            self.menuTableViewTopConstraint.constant = 0
        } else {
            self.menuSearchBar.isHidden = false
            self.categoriesSegmentedControl.isHidden = false
            self.menuTableViewTopConstraint.constant = 108
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
        if searching {
            detailsViewController.drinkId = filteredDrinks[indexPath.row].id
        } else {

            if selectedSegment == 0 {
                detailsViewController.drinkId = freshDrinks[indexPath.row].id
            } else if selectedSegment == 1 {
                detailsViewController.drinkId = hotDrinks[indexPath.row].id
            } else if selectedSegment == 2 {
                detailsViewController.drinkId = softDrinks[indexPath.row].id
            } else if selectedSegment == 3 {
                detailsViewController.drinkId = waterDrinks[indexPath.row].id
            }

        }
        
        self.navigationController?.pushViewController(detailsViewController , animated: true)
    }
}

//MARK: - Search Bar Delegate
extension MenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchOnDrink(drink: searchText)
        searching = true
        if searchText.isEmpty {
            searching = false
        }
        menuTableView.reloadData()
    }
}

//MARK: - Text Field Delegate
extension MenuViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


//MARK: - Firestore Methods
extension MenuViewController {
    
    func loadFreshDrinks() {
        db.collection("drinks").whereField("type", isEqualTo: "fresh-drink").getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.freshDrinks.append(DrinkModel(
                        id: data["id"] as! String,
                        name: data["name"] as! String,
                        type: data["type"] as! String,
                        description: data["description"] as! String,
                        price: data["price"] as! [Int],
                        rate: data["rate"] as? Int,
                        image: data["image"] as? String))
                }
                DispatchQueue.main.async {
                    self?.menuTableView.reloadData()
                }
                
            }
        }
    }
    
    func loadHotDrinks() {
        db.collection("drinks").whereField("type", isEqualTo: "hot-drink").getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.hotDrinks.append(DrinkModel(
                        id: data["id"] as! String,
                        name: data["name"] as! String,
                        type: data["type"] as! String,
                        description: data["description"] as! String,
                        price: data["price"] as! [Int],
                        rate: data["rate"] as? Int,
                        image: data["image"] as? String))
                }
                DispatchQueue.main.async {
                    self?.menuTableView.reloadData()
                }
                
            }
        }
    }
    
    func loadSoftDrinks() {
        db.collection("drinks").whereField("type", isEqualTo: "soft-drink").getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.softDrinks.append(DrinkModel(
                        id: data["id"] as! String,
                        name: data["name"] as! String,
                        type: data["type"] as! String,
                        description: data["description"] as! String,
                        price: data["price"] as! [Int],
                        rate: data["rate"] as? Int,
                        image: data["image"] as? String))
                }
                DispatchQueue.main.async {
                    self?.menuTableView.reloadData()
                }
                
            }
        }
    }
    
    func loadWaterDrinks() {
        db.collection("drinks").whereField("type", isEqualTo: "water-drink").getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.waterDrinks.append(DrinkModel(
                        id: data["id"] as! String,
                        name: data["name"] as! String,
                        type: data["type"] as! String,
                        description: data["description"] as! String,
                        price: data["price"] as! [Int],
                        rate: data["rate"] as? Int,
                        image: data["image"] as? String))
                }
                DispatchQueue.main.async {
                    self?.menuTableView.reloadData()
                }
                
            }
        }
    }
    
    func searchOnDrink(drink: String) {
//        db.collection("drinks").whereField(
//        let myPredicate = NSPredicate(format: "name contains[c] '\(drink)'")
        db.collection("drinks")
            .whereField("name", isLessThan: drink)
            .whereField("name", isGreaterThanOrEqualTo: drink)
            .getDocuments {
            [weak self] (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self?.filteredDrinks.append(DrinkModel(
                        id: data["id"] as! String,
                        name: data["name"] as! String,
                        type: data["type"] as! String,
                        description: data["description"] as! String,
                        price: data["price"] as! [Int],
                        rate: data["rate"] as? Int,
                        image: data["image"] as? String))
                }
                DispatchQueue.main.async {
                    self?.menuTableView.reloadData()
                }
                
            }
        }
        filteredDrinks.removeAll()
    }
    
}
