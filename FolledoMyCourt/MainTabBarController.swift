//
//  MainTabBarController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .green
        checkLoggedInUserStatus()
        setupViewController()
    
    }
    
    fileprivate func checkLoggedInUserStatus() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginViewController = LoginViewController()
                let loginNavigationController = UINavigationController(rootViewController: loginViewController)
                self.present(loginNavigationController, animated: true, completion: nil)
                return
            }
        }
    }
    
    fileprivate func setupViewController() {
        let createGameViewController = CreateGameViewController()
        let createGameNavigationController = UINavigationController(rootViewController: createGameViewController) //puts the VC as the rootVC of this navigationController
        createGameNavigationController.tabBarItem.image = UIImage(named: "basketball")?.withRenderingMode(.alwaysTemplate) //assigns an image of the tabBar
        createGameNavigationController.tabBarItem.selectedImage = UIImage(named: "basketball")?.withRenderingMode(.alwaysTemplate)
        
        let homeMapViewController = HomeMapViewController()
        let homeMapNavigationController = UINavigationController(rootViewController: homeMapViewController)
        homeMapNavigationController.tabBarItem.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate) //assigns an image of the tabBar
        homeMapNavigationController.tabBarItem.selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        //MainTabBarController.select(homeMapViewController)
        //self.tabBarController?.selectedViewController = self.tabBarItem.homeMapViewController
        
        let swipeUsersViewController = SwipeUsersViewController()
        let swipeUsersNavigationController = UINavigationController(rootViewController: swipeUsersViewController)
        swipeUsersNavigationController.tabBarItem.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate) //assigns an image of the tabBar
        swipeUsersNavigationController.tabBarItem.selectedImage = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
        
        let eventViewController = EventViewController()
        let eventNavigationController = UINavigationController(rootViewController: eventViewController)
        eventNavigationController.tabBarItem.image = UIImage(named: "event")?.withRenderingMode(.alwaysTemplate) //assigns an image of the tabBar
        eventNavigationController.tabBarItem.selectedImage = UIImage(named: "event")?.withRenderingMode(.alwaysTemplate)
    
        viewControllers = [createGameNavigationController, homeMapNavigationController, swipeUsersNavigationController, eventNavigationController]
        
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0) //top, left, bottom, right
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedIndex = 1
    }


}
