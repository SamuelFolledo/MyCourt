//
//  SwipeUsersViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SwipeUsersViewController: UIViewController {
    
    private let agePickerDataSource = ["Same Age", "±1 Year", "±2 Years", "±3 Years", "±5 Years", "Anyone"]
    private let distancePickerDataSource = ["" , ""]
    
    var ageArray:[String] = [ ]
    var heightArray:[String] = Array()
    var distanceArray:[String] = Array()
    var specialArray:[String] = Array()
    
//    var fullName: String?
    
    @IBOutlet weak var opponentImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var winLoseLabel: UILabel!
    
    @IBOutlet weak var homeCourtLabel: UILabel!
    @IBOutlet weak var awayCourtLabel: UILabel!
    @IBOutlet weak var awayCourt2Label: UILabel!
    @IBOutlet weak var bestAttributesLabel: UILabel!
    @IBOutlet weak var myMessageLabel: UILabel!
    
    @IBOutlet weak var filterPickerView: UIPickerView!
    
   
    
    
    var displayUserID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        
        filterPickerView.dataSource = self
        filterPickerView.delegate = self
//        filterPickerView.backgroundColor = .darkGray
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:))) //2 //5mins
        opponentImageView.addGestureRecognizer(gesture) //2 //6mins //this add the gesture on swipeLabel. Make sure to check "User Interaction Enabled" in the storyboard
        
//        if let username = PFUser.current()?.username {
//            self.navItem.title = "Hi \(username)"
//        }
        
        setupViews()
        
    }
    
    
//wasDragged 2
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) { //2 //5mins
        //print("dragged")
        //7mins where is the user is trying to move outlets to
        let labelPoint = gestureRecognizer.translation(in: view) //2 //7mins translation returns a point identifying the new location of a view in the coordinate system of its designated superview
        opponentImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y) //2 //8mins How we update where this label should be. //The x means the width of the screen divided by 2 because it is in the middle + whatever the value is of labelPoint.x
        //print("x:\(swipeLabel.center.x) , y:\(swipeLabel.center.y)")
        
        let xFromCenter = view.bounds.width / 2 - opponentImageView.center.x //2 //22mins middle of screen - middle of label
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200) //2 //18mins An affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw in a graphics context
        
        let scale = min(100 / abs(xFromCenter), 1) //2 //24mins //cool effect as it approaches the edge, but the middle would turn too big //25mins //'min' gives perfect effect going to the left, but going to the right it would still get bigger //27mins put 'abs' to keep xFromCenter always positive
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale) //2 //19mins would shrink it a little bit
        opponentImageView.transform = scaledAndRotated //2 //20mins //dont forget to revert back to their original position, size, rotation in .ended state
        
        if gestureRecognizer.state == .ended { //2 //12mins if gesture recognizer ended //this is now where we decide if they move far enough to the left or right
            
            var acceptedOrRejected = "" //6 //28mins create a new variable if the swipe has ended
            
            if opponentImageView.center.x < (view.bounds.width / 2 - 150) { //2 //12mins
                print("not interested") //2 //12mins
                acceptedOrRejected = "rejected" //6 //28mins var to put on the rejected array attributes of the user
                
            } //2 //12mins
            if opponentImageView.center.x > (view.bounds.width / 2 + 150) { //2 //12mins
                print("interested") //2 //12mins
                acceptedOrRejected = "accepted" //6 //28mins
            } //2 //12mins
//
//            if acceptedOrRejected != "" && displayUserID != "" { //6 //31mins check if they have values first
//
//                PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedOrRejected) //6 //31mins this is how you can add it to an array //'addUniqueObject' Adds an object to the array associated with a given key, only if it is not already present in the array. The position of the insert is not guaranteed. //so here we are taking our displayUserID and add it to either our accepted or rejected array attributes
//
//                PFUser.current()?.saveInBackground(block: { (success, error) in //6 //32mins now that we have added another's userID, we want to save and update the Parse Server
//                    if success { //6 //32mins if saving happened successfully, run our updateImage to view the next user
//                        self.updateImage() //6 32mins we should now be able to see other users' objectID in our array of either accepted or rejected
//                    }
//                })
//            }
            
            
            rotation = CGAffineTransform(rotationAngle: 0) //2 //28mins go back to its original rotation
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1) //2 //28mins and their original size
            opponentImageView.transform = scaledAndRotated //2 //29mins apply the transformation to swipeLabel
            
            opponentImageView.center = CGPoint(x: view.bounds.width / 2 , y:  view.bounds.height / 2 - 10) //2 //15mins puts the label back to the center of the screen
            
        } //2 end of .ended state
        
    } //2 end of wasDragged method
    
    
    @IBAction func snapsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToSnapsSegue", sender: nil)
    }
    
}




extension SwipeUsersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
//    func pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
        }
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        myMessageLabel.text = agePickerDataSource[row]
    }
    
//title will be our data source
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return agePickerDataSource[row]
//    }
    
//method for editing each view of the rows in the pickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 16)
        label.text = agePickerDataSource[row]
        
        return label
    }
    
    
    func setupViews() {
        
        if let uid = Auth.auth().currentUser?.uid { //unwrap the currentUser's uid
            
//            print("UID = \(uid)")
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in //listen for a single value, which is the current user
                print("observed")
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    //                    if let userName:String = dictionary["name"] as? String {
                    //                        print(userName)
                    //                        self.navigationItem.title = userName //set the title as the name from the snapshot //changed
                    
                    let user = MyCourtUser(dictionary: dictionary) //ep.7
                    self.nameLabel.text = user.name
                    
                    if let profileImageUrl = user.profileImageUrl { //ep.7
                        self.opponentImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                    
                }
                
            }, withCancel: nil) //withCancel nil is safer and less error
        }
        
    }
    
}
