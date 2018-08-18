//
//  SnapsTableViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/25/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase //4 //1mins

class SnapsTableViewController: UITableViewController {

    var snaps: [DataSnapshot] = [] //4 //4mins //A FIRDataSnapshot contains data from a Firebase Database location. Any time you read Firebase data, you receive the data as a FIRDataSnapshot
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserUid = Auth.auth().currentUser?.uid {//4 //2mins get the current user's uid
            
            Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childAdded) { (snapshot) in //4 //3mins get the users and observe the currentUserUid's list of snaps
                
                self.snaps.append(snapshot) //SC4 //3mins take as many snaps we have and put them in an array, where we can append
                self.tableView.reloadData() //5mins
                
                Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in //SC4 //35mins we observe but for '.childRemove' which is a child node is removed from a location.
                    
                 //SC4 //36mins //loop through each of the objects inside of the snaps array and once we find one that matches this, we can delete it
                    var indexCounter = 0
                    for snap in self.snaps { //SC4 //36mins
                        if snapshot.key == snap.key { //SC4 //37mins
                            self.snaps.remove(at: indexCounter) //SC4 //37mins
                        }
                        indexCounter += 1
                    }
                    self.tableView.reloadData() //SC4 //38mins
                    
                }) //end of observing .childRemoved
                
                
            }//end of observing .childAdded
        }
        
    }
    
    
    
//numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if snaps.count == 0 { //SC4 //39mins
            return 1 //SC4 //39mins
        } else {
            return snaps.count
        }
    }

//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell() //4 //5mins
        
        if snaps.count == 0 { //SC4 //40mins
            cell.textLabel?.text = "You don't have any snaps! 😢" //SC4 //40mins
        } else {
            let snap = snaps[indexPath.row] //4 //5mins
            if let snapDictionary = snap.value as? NSDictionary { //4 //6mins
                if let fromEmail = snapDictionary["from"] as? String { //4 //7mins
                    cell.textLabel?.text = fromEmail //4 //7mins the text will be the email you received the snap from
                }
            }
        }
        
        return cell
    }
    
//didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //4 //13mins
        
        if snaps.count == 0 {
            return
        } else {
        
            let snap = snaps[indexPath.row] //4 //14mins for sending the particular snapshot so that we can see that particular snapshot and pass forward that snap object when we perform segue
            performSegue(withIdentifier: "viewSnapSegue", sender: snap) //4 //13mins
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //4 //14mins
        
        if segue.identifier == "viewSnapSegue" { //4 //15mins we have to check which segue because this VC has 2 segues
            if let viewVC = segue.destination as? ViewSnapViewController {
                if let snap = sender as? DataSnapshot { //4 //16mins unwrap our sender before we can assign the snap
                    viewVC.snap = snap //4 //17mins
                }
            }
        }
        
    }
    

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
