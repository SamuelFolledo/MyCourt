//
//  MainTabBarController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainTabBarController: UITabBarController {
    
    var tabIndex: Int = 1
//    var blurEffectView: UIVisualEffectView?
//    var userInfo: UserInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self as? UITabBarControllerDelegate
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
//        
//        let vc = Service.showAlert(on: self, style: .alert, title: "Welcome to MyCourt", message: "\(userInfo.name)! Let's whoop some ass")
//        self.present(vc, animated: true, completion: nil)
//        
        
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
//            if self.blurEffectView != nil {
//                self.blurEffectView?.isHidden = true
//            } else { return }
//        }
//        let alert = Service.showAlert(on: self, style: .alert, title: "Welcome to MyCourt", message: "\(self.userInfo.name)! Let's whoop some ass", actions: [okAction])
//        self.present(alert, animated: true, completion: nil)

        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print(item)
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .white
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkLoggedInUserStatus()
        //blurryView()
        self.selectedIndex = tabIndex
    }

//    func blurryView() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView?.frame = view.bounds
//        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurEffectView!)
//    }
//    

    @objc func logoutTapped() {
        do {
            try Auth.auth().signOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
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
                
                let loginController = LoginController()
                self.present(loginController, animated: true, completion: nil) //launch login controller
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
