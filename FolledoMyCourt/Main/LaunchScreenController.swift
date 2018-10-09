//
//  LaunchScreenController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 10/6/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchScreenController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    let name = UserDefaults.standard.string(forKey: "name") ?? "" //retrieving string from UserDefaults
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        
        loadAndCheckEverything()
        
        
    }
    
    
    private func loadAndCheckEverything() {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { //animate activityIndicator for 2.5 seconds
            self.activityIndicator.stopAnimating()
            
            if self.name.isEmpty { //if name is empty then logout
                self.checkLoggedInUserStatus() //checked loggin user and go to logout if there is no user signed in
            } else { //else navigate to MainTabController
                AppDelegate.shared.rootViewController.switchToMainScreen()
            }
            
        }
        
    }
    
    
    @objc func logoutTapped() {
        do {
            try Auth.auth().signOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
            Service.clearUserDefaults()
            //self.present(loginViewController, animated: true, completion: nil)
            //            self.performSegue(withIdentifier: "mainTabBarToLoginSegue", sender: nil)
        } catch let error {
            let alert:UIAlertController = Service.showAlert(on: self, style: .alert, title: "Logout Error", message: error.localizedDescription)
            present(alert, animated: true, completion: nil)
            //print(error)
        }
    }
    
    
    
    //check if app has a current user logged in
    fileprivate func checkLoggedInUserStatus() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.perform(#selector(self.logoutTapped), with: nil, afterDelay: 0) //log out with a very small delay
                print("No current logged in user... Logging out")
                
                AppDelegate.shared.rootViewController.switchToLogout()
//                let loginController = LoginController()
//                self.present(loginController, animated: true, completion: nil) //launch login controller
            }
        }
        //        else {
        //            if let userID = Auth.auth().currentUser?.uid {
        //                Database.database().reference().child("users").child(userID).observe(.value) { (snapshot) in
        //                    DispatchQueue.main.async {
        //                        if let name = snapshot.value!["name"] as String {
        //
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
    
}
