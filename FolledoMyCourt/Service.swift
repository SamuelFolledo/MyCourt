//
//  Service.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/14/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class Service {
    
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor = UIColor.white
    static let buttonBackgroundColorSignInAnonymously = UIColor(red: 88, green: 86, blue: 214, alpha: 1)
    static let buttonCornerRadius: CGFloat = 7
    
//showAlert
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil ) -> UIAlertController { //Signin Anonymously //30mins
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        //        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil) //dismiss action
        //        alert.addAction(action)
        for action in actions { //to have as much actions as possible, then we loop through it
            alert.addAction(action)
        }
        //on.present(alert, animated: true, completion: completion) //we add a completion, so we can do something when showAlert is presented
        return alert
    }
    
//presentAlert
    static func presentAlert(on: UIViewController, title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        on.present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) { //gave padding a default value of zero
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
    }
    
    
//    func checkCurrentUser() {
//        let storageRef = Storage.storage().reference()
//        let databaseRef = Database.database().reference()
//        if Auth.auth().currentUser == nil{
////            dispatch_async(dispatch_get_main_queue(), {() -> Void in
//            DispatchQueue.main.async {
//                let loginController = LoginController()
//                self.present(loginController, animated: true, completion: nil)
//            }
//            
//        } else {
//            //observe userLogin
////            Analytics.logEventWithName(kFIREventLogin, parameters: nil)
//            let userID = FIRAuth.auth()?.currentUser?.uid
//            
//            self.databaseRef.child("users").child(userID!).observeEventType(.Value, withBlock: { (snapshot) in
//                // Get user value
//                dispatch_async(dispatch_get_main_queue()){
//                    let username = snapshot.value!["username"] as! String
//                    self.userNameLabel.text = username
//                    // check if user has photo
//                    if snapshot.hasChild("userPhoto"){
//                        // set image locatin
//                        let filePath = "\(userID!)/\("userPhoto")"
//                        // Assuming a < 10MB file, though you can change that
//                        self.storageRef.child(filePath).dataWithMaxSize(10*1024*1024, completion: { (data, error) in
//                            let userPhoto = UIImage(data: data!)
//                            self.userPhoto.image = userPhoto
//                        })
//                    }
//                    
//                }
//                
//            })
//        }
//    }
    
}

/*
 (void) setup {
 
 //View 1
 UIView *view1 = [[UIView alloc] init];
 view1.backgroundColor = [UIColor blueColor];
 [view1.heightAnchor constraintEqualToConstant:100].active = true;
 [view1.widthAnchor constraintEqualToConstant:120].active = true;
 
 
 //View 2
 UIView *view2 = [[UIView alloc] init];
 view2.backgroundColor = [UIColor greenColor];
 [view2.heightAnchor constraintEqualToConstant:100].active = true;
 [view2.widthAnchor constraintEqualToConstant:70].active = true;
 
 //View 3
 UIView *view3 = [[UIView alloc] init];
 view3.backgroundColor = [UIColor magentaColor];
 [view3.heightAnchor constraintEqualToConstant:100].active = true;
 [view3.widthAnchor constraintEqualToConstant:180].active = true;
 
 //Stack View
 UIStackView *stackView = [[UIStackView alloc] init];
 
 stackView.axis = UILayoutConstraintAxisVertical;
 stackView.distribution = UIStackViewDistributionEqualSpacing;
 stackView.alignment = UIStackViewAlignmentCenter;
 stackView.spacing = 30;
 
 
 [stackView addArrangedSubview:view1];
 [stackView addArrangedSubview:view2];
 [stackView addArrangedSubview:view3];
 
 stackView.translatesAutoresizingMaskIntoConstraints = false;
 [self.view addSubview:stackView];
 
 
 //Layout for Stack View
 [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
 [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
 }
 */
