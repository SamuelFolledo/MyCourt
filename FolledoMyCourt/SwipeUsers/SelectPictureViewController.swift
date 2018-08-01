//
//  SelectPictureViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/25/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseStorage //3 //1mins

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var imagePicker: UIImagePickerController?
    var imageAdded = false
    var imageName = "FolledoCourtImages1_\(NSUUID().uuidString).jpg" //3 //5mins will create a unique string that is guaranteed to not equal to anything else
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        
    }

    @IBAction func selectPhotoTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//method ran after not canceling the imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
//******** DELETE THIS FOR PRODUCTION ***********//
//        messageTextField.text = "test"
//        imageAdded = true //3 //11mins makes debugging faster
//
        
        if let message = messageTextField.text {
            if imageAdded && message != "" { //if we reach this point, we know everything works and we can segue
                
            //Upload image
                let imagesFolder = Storage.storage().reference().child("images") //3 //3mins //where we gonna store all of our images in our app
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1) {//3 //4mins compress the image stored to 0.1 so it doesnt take too much space
                        
                    //***then now we upload***
                        //let imageName: String = "FolledoCourtImages1_\(NSUUID().uuidString).jpg" //3 //5mins add a child to our imagesFolder // 'NSUUID.init(uuidString: String )' we need a unique id to represent our image, Apple has a great class for that, "will create a unique string that is guaranteed to not equal to anything else" //removed at //SC4 //30mins
                        
                        let imageReference = imagesFolder.child(imageName)
//                        let path = imageReference.fullPath //File path is "images/space.jpg"
//                        let name = imageReference.name //File name is "space.jpg"
//                        let images = imageReference.parent() //points to "images"
                        
                        imageReference.putData(imageData, metadata: nil) { (metadata, error) in //puts data in the imageFolder //3 //6mins we want 'putData(uploadData, metadata: , completion: )'choose where we can provide some data with a completion handler to know how it all worked out
                            if let error = error {  //3 //7mins error occurred
                                print("XXXXXNo metadata foundXXXXX")
                                Service.presentAlert(on: self, title: "Uploading Image failed", message: error.localizedDescription) //3 //8mins
                                return
                            } else { //no error in putting imageData so segue to next view controller
                                
                                
                                imageReference.downloadURL { (imageUrl, error) in //updated version in Firebase //3 //14mins //before segueing we need to download URL for the next ViewController, so they can access it
                                    
                                    if let error = error { //3 //7mins
                                        Service.presentAlert(on: self, title: "Error in Images", message: error.localizedDescription) //3 //8mins
                                    } else { //3 //12mins //if no error then segue to next VC
                                        //3 //12mins //we gotta know the particular uiid, and the folder's url
                                        
                                        if let downloadURL = imageUrl?.absoluteString { //3 //14mins turn url to a string that we can use for our segue
                                            self.performSegue(withIdentifier: "selectReceiverSegue", sender: downloadURL) //3 //14mins
                                            
                                            /* //3 //18-21mins
                                             Go to Firebase - Database - Realtime Database - Data
                                             1) add users
                                             a) (identifier) qpiwe123ij1l1238fasn
                                             aa) which will contain an email
                                             ab) which will contain snaps
                                             aba) (each snaps will have -identifier) akljda390e1lhj1je
                                             aba1) each snapIdentifier will have description
                                             aba2) each snapIdentifier will have fromEmail
                                             aba3) each snapIdentifier will have imageURL
                                             
                                             The idea is when a user signs up for the first time we should make a new object or child for them which has a random string and then it has their email inside of there. Then when someone sends that person a snap we we're going to add on to their snap's child here with the randomId but then it's going to have the description, who was from that image, and imageURL
                                             
                                             */
                                        } // end of unwrapping imageURL and performing segue
                                    } //errorleess downloading imageURL
                                } //end of downloading imageURL
                            } //errorless putData
                        } //end of putData
                    } //end of imageData
                }
                
            } else { //we are missing something
    
                Service.presentAlert(on: self, title: "Error" , message: "You must provide an image and a message to continue")
            }
        }
    }

    
    
//prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //3 //16mins
        
        if let downloadURL = sender as? String { //SC3 //16mins
            if let selectVC = segue.destination as? SelectRecipientTableViewController { //SC3 //18mins
                if let description = messageTextField.text {
                    selectVC.downloadURL = downloadURL //SC3 //18mins
                    selectVC.snapDescription = description //SC3 //36mins
                    selectVC.imageName = imageName //selectVC image name is now equal to this VC's imageName
                }
            }
        }
        
    }
    
}


