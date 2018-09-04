//
//  MessagesController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/2/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MessagesController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        
        
        let image = UIImage(named: "new_message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        
        checkCurrentUser()
        
        
    }
    
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

    
    
    func checkCurrentUser() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            if let uid = Auth.auth().currentUser?.uid { //unwrap the currentUser's uid
                
                print("UID = \(uid)")
                Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in //listen for a single value, which is the current user
                    print("observed")
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        print("got the dict")
                        print(dictionary)
                        if let userName = dictionary["name"] as? String {
                            print(userName)
                            self.navigationItem.title = userName //set the title as the name from the snapshot
                        }
                    }
                    
                }, withCancel: nil) //withCancel nil is safer and less error
            }
        }
    }
    
    
    
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do { try Auth.auth().signOut() }
        catch let logoutError {
            Service.presentAlert(on: self, title: "Logout Error", message: (logoutError as? String)!)
        }
        
        let loginController = LoginController()
        self.present(loginController, animated: true, completion: nil)
    }
    
}
