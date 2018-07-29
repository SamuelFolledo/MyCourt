//
//  SwipeUsersViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class SwipeUsersViewController: UIViewController {

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //view.backgroundColor = .yellow
        //navigationItem.title = "Swipe"
        
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
    }
    
}
