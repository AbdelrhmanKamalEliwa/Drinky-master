//
//  AboutUsViewController.swift
//  Drinky
//
//  Created by Awady on 5/5/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var holderBackgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseTouch()
    }
    
    func setupCloseTouch() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AboutUsViewController.closeTab(_:)))
        holderBackgroundView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTab(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotItPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
