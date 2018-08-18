//
//  SelectRecipientTableViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/28/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectRecipientTableViewController: UITableViewController {

    var snapDescription: String = "" //3 //17mins
    var downloadURL: String = "" //3 //17mins
    var imageName: String = "" //SC4 //29mins
    var users: [User] = [] //3 //SC3 //30mins
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(downloadURL)
        //Service.presentAlert(on: self, title: "Uploading image to Firebase successfuly!", message: "Here is your following URL:\n\(downloadURL)")
        
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in //3 //26mins
            let user = User()
            //if let userDictionary = snapshot.value as? NSDictionary { //3 //28mins snapshot should come as a dictionary
            if let userDictionary = snapshot.value as? [String:AnyObject] { //3 //28mins snapshot should come as a dictionary
            
                if let email = userDictionary["email"] as? String { //3 //29mins
                    user.email = email //3 //30mins
                    user.uid = snapshot.key //3 //30mins equal the uid to the snapshot key
                    self.users.append(user) //3 //30mins now append this to our users array //now we have to make it show up
                    self.tableView.reloadData() //SC3 //32mins
                }
                
            }
        }
        
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count //SC3 //31mins
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //SC3 //31mins
        let cell = UITableViewCell() //SC3 //31mins
        let user = users[indexPath.row] //SC3 //31mins
        
        cell.textLabel?.text = user.email //SC3 //31mins makes the cell's text the User class's email
        return cell //SC3 //31mins
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //SC3 //33mins
        let user = users[indexPath.row] //SC3 //34mins
        
        if let fromEmail = Auth.auth().currentUser?.email { //SC3 //35mins
        
            let snapDictionary: Dictionary = ["from": fromEmail, "description":snapDescription, "imageURL": downloadURL, "imageName": imageName] //SC3 //37mins
            //***** now that we have a snap, it is just a matter of adding it to the correct user *****
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snapDictionary) //SC3 //38mins the .child(user.uid), now we know who we're sending to. Then go to the "snaps" child, then on this we want to do a child by autoID to say go ahead and pick a random thing for us and set the value for this as our snapDictionary
            
            //****  the last thing we want to do, is once the user has successfully sent you the snap, we want to pop them back to the original VC  ******
            navigationController?.popToRootViewController(animated: true) //SC3 //40mins
        }
        
    }





}


class User { //3 //28mins
    var email: String = ""
    var uid: String = ""
}
