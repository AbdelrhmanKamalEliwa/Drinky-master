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
    
    private let db = Firestore.firestore()
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var pagingDots: UIPageControl!
    @IBOutlet private weak var registerbutton: UIButton!
    @IBOutlet private weak var loginbutton: UIButton!
    @IBOutlet private weak var loginWithFacebookButton: UIButton!
    
    
    
    private let images = [UIImage(named: "image- 1"), UIImage(named: "image- 2"), UIImage(named: "image- 3"), UIImage(named: "image- 4"), UIImage(named: "image- 5")]
    private var pageIndex = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        pagingDots.numberOfPages = images.count
        imagesScrollTimer()
    }

    private func registerCollectionCell() {
        let nibCell = UINib(nibName: "SliderImageViewCell", bundle: nil)
        self.imagesCollectionView.register(nibCell, forCellWithReuseIdentifier: "SliderImageViewCell")
    }
    
    private func imagesScrollTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    @objc func timerAction() {
        let scrollPosition = (pageIndex < images.count - 1) ? pageIndex + 1 : 0
        imagesCollectionView.scrollToItem(at: IndexPath(item: scrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction private func registerPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let registerViewController = storyboard.instantiateViewController(identifier: "RegisterViewController") as RegisterViewController
        registerViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction private func loginPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController") as LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction private func loginFacebookPressed(_ sender: Any) {
        loginWithFacebook()
    }
    
    private func loginWithFacebook() {
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
    
    private func loginToFirestore() {
        guard let token = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                self?.presentSimpleAlert(viewController: self!, title: "Login Failure", message: error.localizedDescription)
                return
            }
            self?.getFBUserData()
            self?.goToHome()
        }
    }
    
    
    private func getFBUserData() {
        guard AccessToken.current != nil else {
            presentSimpleAlert(viewController: self, title: "Error", message: "Login Failure")
            return
        }
        
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name"])
        graphRequest.start(completionHandler: { [weak self] (connection, result, error) -> Void in
            guard error == nil else {
                self?.presentSimpleAlert(viewController: self!, title: "Login Failure", message: error!.localizedDescription)
                return
            }
            guard let result = result else {
                self?.presentSimpleAlert(viewController: self!, title: "Login Failure", message: "Failed to load data")
                return
            }
            let dict = result as! [String : AnyObject]
            let data = dict as NSDictionary
            let firstName = data.object(forKey: "first_name") as! String
            let lastName = data.object(forKey: "last_name") as! String
            let email = data.object(forKey: "email") as! String
            let id = Auth.auth().currentUser!.uid
            self?.createUserInfo(id, firstName, lastName, email)
        })
        
    }
    
    private func createUserInfo(_ userId: String, _ firstName: String, _ lastName: String, _ email: String) {
        let newDocument = db.collection("registed-user").document(userId)
        newDocument.setData([
            "first-name":firstName,
            "last-name":lastName,
            "email":email,
            "mobile-number":"Not Founded",
            "address": "Not Founded",
            "id":userId
        ])
    }
    
    private func goToHome() {
        performSegue(withIdentifier: "goToHomeWithFB", sender: self)
    }

}

extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageViewCell", for: indexPath) as! SliderImageViewCell
        cell.imageCell = images[indexPath.item]
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

