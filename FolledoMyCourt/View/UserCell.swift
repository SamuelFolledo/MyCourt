//
//  UserCell.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/12/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

//UserCell //needed for our programmatically cellForRowAt
class UserCell: UITableViewCell { //is the UserCell we registered to our TableView
    
//ep. 10 it should be UserCell's job to keep track of the message, and the cellForRowAt from MessagesController should only return the cell
    var message: ChatMessage? { //ep.10
        didSet {
            setupNameAndProfileImage() //ep.11
            detailTextLabel?.text = message?.text //ep.10 //assign the message in .detailTextLabel
            
            if let seconds = message?.timeStamp?.doubleValue { //ep.10
                let timeStampDate = NSDate.init(timeIntervalSince1970: seconds) //ep.10
                let dateFormatter = DateFormatter() //ep.10
                dateFormatter.dateFormat = "hh:mm:ss a" //ep.10 "12:01:37 PM"
//                timeLabel.text = timeStampDate.description //ep.10 return the string version. Remember to format the date
                timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
            }
        }
    }
    
    override func layoutSubviews() { //after adding the profileImage, now the labels are underneath the image, this func will fix it
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 4, width: textLabel!.frame.width, height: textLabel!.frame.height) //everything is correct by default except for the x value, and now put more spacing between the two labels
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height + 5)
    }
    
    private func setupNameAndProfileImage() { //ep.11 created a func for it instead of having it in didSet
        
        //ep.10 to get the name displayed instead of the uid
        if let id = message?.chatPartnerId() { //ep.10 //ep.12 changed to chatPartnerId
            let ref = Database.database().reference().child("users").child(id) //ep.10 //having the reference set here, now we can observe the value! //ep.11 userUid is changed to id from chatPartnerId in order to reference the right "profileImageUrl"
            
            ref.observe(.value, with: { (snapshot) in //ep.10 observe the value and unwrap the dictionary
                
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    let name = dictionary["name"] as? String
                    
                    self.textLabel?.text = name //assign the textLabel
                    //                        cell.textLabel?.text = name //assign the name ep.10 //putting this didSet here in the UserCell from MEssagesController, we dont have to include the cell anymore, as well as for profileImageView
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                //                print(ref + snapshot)
            }, withCancel: nil) //ep.10
        }
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
    
    
//timeLabel
    let timeLabel: UILabel = { //ep.10
        let label = UILabel() //ep.10
//        label.text = "HH:MM:SS" //ep.10
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13)
        return label //ep.10
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        //add it to the view and constraint
        addSubview(profileImageView) //ep.6
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    //timeLabel
        addSubview(timeLabel) //ep.10
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        
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
