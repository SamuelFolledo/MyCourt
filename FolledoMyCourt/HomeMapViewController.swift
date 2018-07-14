//
//  HomeMapViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class HomeMapViewController: UIViewController {

    lazy var profileButton: UIButton = {
        var button = UIButton(type: .custom)
        //button.backgroundImage(for: .normal) = UIImage(named: "user")
        button.setImage(UIImage(named: "user"), for: .normal)
        button.layer.masksToBounds = true //this enables us to have a corner radius
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        navigationItem.title = "Map"
        
        view.addSubview(profileButton)
        profileButton.center = self.view.center
        
    }
    
    @objc func profileButtonTapped() {
        let userProfileViewController = UserProfileViewController()
        self.present(userProfileViewController, animated: true, completion: nil)
    }
    


}
