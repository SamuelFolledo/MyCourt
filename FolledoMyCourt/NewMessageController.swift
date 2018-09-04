//
//  NewMessageController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [MyCourtUser]()
    
    
//viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    
    }
    
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print("user found") //will get printed out the same amount of times as the amount of users
        //add users to an array
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = MyCourtUser(dictionary: dictionary) //each user will be a brand new user
                self.users.append(user)
//                user.setValuesForKeysWithDictionary(dictionary) //ep4 if u use this setter, your app will crash if your class properties dont exactly match up with the firebase dictionary keys
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
            
            
        }, withCancel: nil)
    }
    
    
// ------------------------- tableView delegate method -------------------------
    
    
//numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId) //removed after creating our own tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    
    
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }



}

//UserCell //needed for our programmatically cellForRowAt
class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


