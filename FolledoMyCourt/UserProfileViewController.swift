//
//  UserProfileViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.setNavigationBar()
        
        
        
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 50))
        
        //navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "User Profile")
        
        
        let signoutButton = UIButton()
        signoutButton.frame = CGRect(x:0, y:0, width:40, height:40)
        signoutButton.setImage(UIImage(named: "exit"), for: .normal)
        signoutButton.setImage(UIImage(named: "exit"), for: .highlighted)
        signoutButton.backgroundColor = UIColor.yellow
        signoutButton.layer.cornerRadius = 5.0
        signoutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: signoutButton)
        //self.navigationItem.rightBarButtonItem = rightBarButton
        navItem.rightBarButtonItem = rightBarButton
        
        //let signoutButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(signOutButtonTapped))
        
        
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    

    @objc func signOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            let loginViewController = LoginViewController()
            let loginNavigationController = UINavigationController(rootViewController: loginViewController)
            loginViewController.modalTransitionStyle = .partialCurl
            self.present(loginNavigationController, animated: true, completion: nil)
        } catch let error {
            print(error)
        }
        
        
    }
    
}
