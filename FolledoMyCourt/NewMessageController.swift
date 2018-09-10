//
//  NewMessageController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Firebase


class NewMessageController: UITableViewController {

    let cellId:String = "cellId"
    var users = [MyCourtUser]()
    
    
//viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    
    }
    
    
    func fetchUser() {
        print("Fetching users.....")
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print("user found") //will get printed out the same amount of times as the amount of users
        //add users to an array
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = MyCourtUser(dictionary: dictionary) //each user will be a brand new user
                
//                user.setValuesForKeys(dictionary) //ep4 //17mins if u use this setter, your app will crash if your class properties dont exactly match up with the firebase dictionary keys
//to fix...
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String

                
                
                
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }, withCancel: nil)
    }
    
    
// ------------------------- tableView delegate method -------------------------
    
    
//numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId) //removed after creating our own tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell //ep.6 was casted as UITableViewCell isntead of UserCell to access profileImageView
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.imageView?.contentMode = .scaleAspectFill //ep.6
        
        
    //get our profile image to our cell
        if let profileImageUrl = user.profileImageUrl { //ep.6 check UIImageView extension
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl) //network still constantly firing downloads and downloading images for our view
        }
        
        return cell
    } //end of cellForRowAt
    
//height of table view cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }



}






/*

++++++++++++++++++ CLASS UserCell: UITableViewCell ++++++++++++++++++++++
 
*/


//UserCell //needed for our programmatically cellForRowAt
class UserCell: UITableViewCell { //is the UserCell we registered to our TableView
    
    override func layoutSubviews() { //after adding the profileImage, now the labels are underneath the image, this func will fix it
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 4, width: textLabel!.frame.width, height: textLabel!.frame.height) //everything is correct by default except for the x value, and now put more spacing between the two labels
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 4, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = { //ep.6
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
    //make it round
        imageView.layer.cornerRadius = 25 //20 comes from half of height and width which was 40
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    //add it to the view and constraint
        addSubview(profileImageView) //ep.6
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







/*
 
++++++++++++++++++ EXTENSION UIImageView ++++++++++++++++++++++
 
used for loading images from fire base. It will also keep it downloaded when we leave the viewcontroller and open it again
 
*/

let imageCache = NSCache<NSString, AnyObject>() //NSCache = A mutable collection you use to temporarily store transient key-value pairs that are subject to eviction when resources are low.

extension UIImageView {
    
//this function will download the image, and once downloaded once, it will put it inside the imageCache
    func loadImageUsingCacheWithUrlString(_ urlString: String) { //ep.6
//check cache for image first
        self.image = nil //since we're reusing our cell, it will sometimes use another cell's image to load in the new cell, this will keep it blank
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage //now set it from the setted imageCache
            return
        }
        
        
//otherwise, fire off a new download
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in //ep.6
            
            if let error = error {
                print("Error presenting images\n\(error.localizedDescription)")
                return
                //Service.presentAlert(on: self, title: "Error Loading Image", message: error.localizedDescription)
            } else { //if no error
                DispatchQueue.main.async { //load when every download/retrieves are done
                    if let downloadedImage = UIImage(data: data!) { //ep.6
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        
                    //cell.profileImageView.image = UIImage(data: data!) //ep.6 this addes the image to the UserCell //was this until we created an extension for downloading images
                        self.image = downloadedImage
                    }
                }
            }
        };task.resume() //.resume() to fire off this URL Session request
    }
    
}




