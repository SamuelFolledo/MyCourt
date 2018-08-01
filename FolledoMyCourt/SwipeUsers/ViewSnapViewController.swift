//
//  ViewSnapViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/29/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth //SC4 //25mins
import FirebaseStorage //SC4 //26mins
import SDWebImage //SC4 //22mins

class ViewSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! //4 //12mins
    @IBOutlet weak var messageLabel: UILabel! //4 //12mins
    
    var snap: DataSnapshot? //4 //16mins will contain our snap form SnapsTableVC
    var imageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let snapDictionary = snap?.value as? NSDictionary { //4 //18mins
            if let description = snapDictionary["description"] as? String { //4 //18min
                if let imageURL = snapDictionary["imageURL"] as? String { //4 //19mins //if this all work out, it means we have the description and the imageURL where we can download the image from
                    messageLabel.text = description //4 //19mins
                    
                //download image and put it in the imageView
                    if let url = URL(string: imageURL) { //SC4 //22mins
                        imageView.sd_setImage(with: url) //4 //22mins using SDWebImage to make setting image fast and easy with a url
                    }
                    
                    if let imageName = snapDictionary["imageName"] as? String { //4 //32mins
                        self.imageName = imageName //4 //32mins
                    }
                    
                }
            }
        }

        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) { //SC4 //25mins
        
        if let currentUserUid = Auth.auth().currentUser?.uid { //SC4 //26mins
            if let key = snap?.key {
                Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue() //SC4 //27mins remove the snap from our databse
             Storage.storage().reference().child("images").child(imageName).delete(completion: nil) //SC4 //28mins now delete it from our image folder //after images, we want to find the child with the correct name
                
            }
            
        }
    }
    

}
