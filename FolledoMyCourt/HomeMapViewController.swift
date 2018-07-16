//
//  HomeMapViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import MapKit

class HomeMapViewController: UIViewController {

    
    lazy var profileButton: UIButton = {
        var button = UIButton(type: .system)
        //button.backgroundImage(for: .normal) = UIImage(named: "user")
        //button.setTitle("Hey", for: .normal)
        button.setImage(UIImage(named: "user"), for: .normal)
        //button.layer.masksToBounds = true //this enables us to have a corner radius
        //button.layer.cornerRadius = Service.buttonCornerRadius
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        navigationItem.title = "Map"
        
        view.addSubview(profileButton)
        
        profileButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: -10), size: .init(width: 100, height: 100))

        
    }
    
    @objc func profileButtonTapped() {
        let userProfileViewController = UserProfileViewController()
        userProfileViewController.modalTransitionStyle = .coverVertical
        self.present(userProfileViewController, animated: true, completion: nil)
    }
    


}

