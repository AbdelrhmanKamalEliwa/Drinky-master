//
//  ViewController.swift
//  Drinky
//
//  Created by Awady on 4/29/20.
//  Copyright © 2020 Ahmed Elawady. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin

class IntroViewController: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var pagingDots: UIPageControl!
    @IBOutlet weak var registerbutton: UIButton!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    
    
    
    let images = [UIImage(named: "image- 1"), UIImage(named: "image- 2"), UIImage(named: "image- 3"), UIImage(named: "image- 4"), UIImage(named: "image- 5")]
    var pageIndex = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        pagingDots.numberOfPages = images.count
        imagesScrollTimer()
    }

    func registerCollectionCell() {
        let nibCell = UINib(nibName: "SliderImageViewCell", bundle: nil)
        self.imagesCollectionView.register(nibCell, forCellWithReuseIdentifier: "SliderImageViewCell")
    }
    
    func imagesScrollTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    @objc func timerAction() {
        let scrollPosition = (pageIndex < images.count - 1) ? pageIndex + 1 : 0
        imagesCollectionView.scrollToItem(at: IndexPath(item: scrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let registerViewController = storyboard.instantiateViewController(identifier: "RegisterViewController") as RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController") as LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func loginFacebookPressed(_ sender: Any) {
        loginWithFacebook()
    }
    
    func loginWithFacebook() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) {
            [weak self] (result) in
            switch result {
            case .success(granted: _, declined: _, token: _):
                self?.loginToFirestore()
            case .cancelled:
                print("Cancelled")
            case .failed(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loginToFirestore() {
        guard let token = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("login Success")
            
            guard let currentUser = Auth.auth().currentUser else {
                print("Faild to load current user")
                return
            }
            
            let _ = currentUser.uid
            
//            self?.createUserInfo(userId)
            self?.goToHome()
        }
    }
    
    func goToHome() {
        performSegue(withIdentifier: "goToHomeWithFB", sender: self)
    }

}

extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageViewCell", for: indexPath) as! SliderImageViewCell
        cell.sliderImageCell.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageIndex = Int(scrollView.contentOffset.x / imagesCollectionView.frame.size.width)
        pagingDots.currentPage = pageIndex
    }
}

