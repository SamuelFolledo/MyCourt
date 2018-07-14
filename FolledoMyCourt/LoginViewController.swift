//
//  ViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth //2 //10mins
//import Firebase
import GoogleMobileAds //AdMob //11mins

import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    //var loginButton: FBSDKLoginButton
    lazy var signAnonymouslyButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Sign in Anonymously", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
        Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = .black
        button.layer.masksToBounds = true //this enables us to have a corner radius
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.addTarget(self, action: #selector(handleSignInAnonymouslyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let loginButton = FBSDKLoginButton() //FBLogin //12mins
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        setupViews()
        
        //loginButton.center = self.view.center //FBLogin //12mins
        loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
        
    }
    
//signInAnonymouslyButtonTapped method
    @objc func handleSignInAnonymouslyButtonTapped() {
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                print("Failed to sign in anonymously with error: ",error)
                Service.showAlert(on: self, style: .alert, title: "Sign In Error", message: error.localizedDescription)
                return
            }
            print("Successfully signed in anoynmously with: ", user?.user)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
//loginButtonDidLogOut delegate method
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { //FBLogin //17mins
        print("Did logout of Facebook...") //FBLogin //17mins
    } //FBLogin //17mins
    
//didCompleteWith delegate method
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) { //FBLogin //17mins
        if error != nil { //FBLogin //17mins
            print(error) //FBLogin //17mins
            return //FBLogin //17mins
        } else if result.isCancelled { //FBLogin //17mins if user canceled login
            print("User has canceled login")
        } else { //FBLogin //if successful, meaning no error, and login didnt cancel log in
            if result.grantedPermissions.contains("email"){ //FBLogin //18minsmake sure they gave us permissions
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) { //FBLogin //19mins //FBSDKGraohRequest - represents a request to the Facebook Graph API. //we're looking for "me" only because we dont want anything to do with user's friends. //' parameters: ["fields":"email,name"] ' gives us the email and name
                    graphRequest.start { (connection, result, error) in //FBLogin //20mins, give us connection, result, and error
                        if error != nil { //FBLogin //20mins
                            print(error!) //FBLogin //20mins
                        } else { //FBLogin //20mins if everything worked out...
                            if let userDetails = result { //FBLogin //21mins if no error then we should get the results
                                //print(userDetails)
                                print("Successfuly Log in Facebook: ", userDetails)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    fileprivate func setupViews() {
        //view.addSubview(signAnonymouslyButton)
        
//        let redView = UIView()
//        redView.backgroundColor = .black
//        view.addSubview(redView)
        
        [loginButton, signAnonymouslyButton].forEach { view.addSubview($0) } //adds all the view, '$0' represents one of your items inside of the array
        
        //redView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 8, bottom: 10, right: -8), size: .init(width: 100, height: 100)) //safeAreaLayoutGuide' doesnt allow the button to go over the top of the device's screen
        
        loginButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: -20), size: .init(width: 100, height: 100))
        
        signAnonymouslyButton.anchor(top: loginButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: loginButton.trailingAnchor, padding: .init(top: 10, left: 19, bottom: 0, right: -2), size: .init(width: 100, height: 100))
        
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
}

