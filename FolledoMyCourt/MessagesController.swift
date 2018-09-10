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
        let navController = UINavigationController(rootViewController: newMessageController) //will give us a nav bar
        present(navController, animated: true, completion: nil)
    }

    
    
    func checkCurrentUser() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchCurrentUserAndSetupNavBarTitle()
        }
    }
    
//fetch Current User
    func fetchCurrentUserAndSetupNavBarTitle() {
        if let uid = Auth.auth().currentUser?.uid { //unwrap the currentUser's uid
            
            print("UID = \(uid)")
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in //listen for a single value, which is the current user
                print("observed")
                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    if let userName:String = dictionary["name"] as? String {
//                        print(userName)
//                        self.navigationItem.title = userName //set the title as the name from the snapshot //changed
                        
                    let user = MyCourtUser(dictionary: dictionary) //ep.7
                    self.setupNavBarWithCurrentUser(user: user) //ep.7
                    
                }
                
            }, withCancel: nil) //withCancel nil is safer and less error
        }
    }
    
//navBar that will display current user's image and name to our nav bar
    func setupNavBarWithCurrentUser(user: MyCourtUser) {
        let titleView = UIView() //the titleView which will contain our image and name
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = .red
        
        
    //after adding the titleView, profileImageView, and nameLabel, they dont fit correctly, and the containerView will be our solution
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
    
    //profileImage
        let profileImageView = UIImageView()
        containerView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    //nameLabel
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        
    //containerView constraints
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        print("Current user name and image is loaded")
        self.navigationItem.titleView = titleView
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
        loginController.messagesController = self //ep.7 bug fix
        self.present(loginController, animated: true, completion: nil)
    }
    
}
