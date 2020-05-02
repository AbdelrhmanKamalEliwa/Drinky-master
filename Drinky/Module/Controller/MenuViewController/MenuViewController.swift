//
//  MenuViewController.swift
//  Drinky
//
//  Created by Awady on 5/2/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var menuSearchBar: UISearchBar!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    
    var hotDrinks = ["Tea","Coffee","Latte"]
    var freshDrinks = ["Orange", "Mango", "Banana"]
    var softDrinks = ["Cocacola", "Fanta", "Sprit"]
    var waterDrinks = ["Dasani", "Baraka", "Safi"]
    
    lazy var drinksTodisplay = hotDrinks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerMenuTableView()
        categoriesSegmentedControl.selectedSegmentIndex = 0
        sutupSegmentControlAttributes()
        setupSearchBar()
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.9207810495, blue: 0.8098561175, alpha: 1)
        
    }
    
    func registerMenuTableView() {
        let menuNib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuNib, forCellReuseIdentifier: "MenuTableViewCell")
    }
    
    func setupSearchBar() {
        menuSearchBar.searchBarStyle = .minimal
        menuSearchBar.searchTextField.delegate = self
    }
    
    @IBAction func handleSelectedSegmentControl(_ sender: Any) {
        switch categoriesSegmentedControl.selectedSegmentIndex {
        case 0: drinksTodisplay = hotDrinks
            backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.9207810495, blue: 0.8098561175, alpha: 1)
        case 1: drinksTodisplay = freshDrinks
            backgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.9133522299, blue: 0.9680454037, alpha: 1)
        case 2: drinksTodisplay = softDrinks
            backgroundView.backgroundColor = #colorLiteral(red: 0.9074003146, green: 1, blue: 0.9103867377, alpha: 1)
        default: drinksTodisplay = waterDrinks
            backgroundView.backgroundColor = #colorLiteral(red: 0.8171564551, green: 0.939322343, blue: 1, alpha: 1)
        }
        menuTableView.reloadData()
    }
    
    func sutupSegmentControlAttributes() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        let selectedTextAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)]
        categoriesSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        categoriesSegmentedControl.setTitleTextAttributes(selectedTextAttribute, for: .selected)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinksTodisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.cupName = drinksTodisplay[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension MenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
//            drinksTodisplay = allDrinks
            menuTableView.reloadData()
            return
        }
//        filter Drinks by your logic
        menuTableView.reloadData()
    }
}

extension MenuViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
