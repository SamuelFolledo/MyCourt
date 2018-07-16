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
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let screenStackView = UIStackView()
    
    let loginView: UIView = {
        let loginView = UIView()
        //loginView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        loginView.backgroundColor = .clear
        //loginView.alpha = 0.5
        loginView.translatesAutoresizingMaskIntoConstraints = false
        return loginView
    }()
    
    let loginBackgroundView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .clear
//        let bgImage = UIImageView(frame: self.loginView.bounds)
//        bgImage.backgroundColor = .white
//        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
//        bgView.addSubview(bgImage)
        return bgView
    }()
    
    
    let loginStackView = UIStackView()
    private var confirmPasswordStackView: UIStackView?
    
    private let loginContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.setTitle("Login", for: .normal)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
            Service.buttonTitleFontSize)
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let switchToSignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.setTitle("Switch to Signup", for: .normal)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
            Service.buttonTitleFontSize)
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSignupOrLoginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let fBLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }() //FBLogin //12mins
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        
        
        setupViews()
        
        //loginButton.center = self.view.center //FBLogin //12mins
        fBLoginButton.readPermissions = ["public_profile", "email"]
            fBLoginButton.delegate = self
        
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
    
    
//Facebook loginButtonDidLogOut delegate method
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { //FBLogin //17mins
        print("Did logout of Facebook...") //FBLogin //17mins
    } //FBLogin //17mins
    
//Facebook didCompleteWith delegate method
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
        //redView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 8, bottom: 10, right: -8), size: .init(width: 100, height: 100)) //safeAreaLayoutGuide' doesnt allow the button to go over the top of the device's screen
        
        //-----------------------------------------------------------------------
//        [loginButton, signAnonymouslyButton].forEach { view.addSubview($0) } //adds all the view, '$0' represents one of your items inside of the array
        
        
//        loginContentView.addSubview(usernameTextField)
//        loginContentView.addSubview(passwordTextField)
//        loginContentView.addSubview(loginButton)
//        loginContentView.addSubview(switchToSignupButton)
//        loginContentView.addSubview(fBLoginButton)
//        loginContentView.addSubview(signAnonymouslyButton)
//
        
        //loginView
        view.addSubview(loginView)
        //loginView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: -10), size: .init(width: screenSize.width / 1.1, height: screenSize.height / 2))

        
        //view.addSubview(loginContentView)
        self.loginView.addSubview(loginBackgroundView)
        self.loginView.addSubview(loginStackView)
        //loginStackView.sizeToFit()
        
        let loginBGImage = UIImageView(frame: self.loginView.bounds)
        loginBGImage.backgroundColor = .darkGray
        loginBGImage.image = UIImage(named: "loginBackground")
        loginBGImage.clipsToBounds = true //A Boolean value that determines whether subviews are confined to the bounds of the view
        loginBGImage.contentMode = .scaleAspectFill //A flag used to determine how a view lays out its content when its bounds change.
        loginBGImage.alpha = 1
        loginBGImage.translatesAutoresizingMaskIntoConstraints = false
        self.loginBackgroundView.addSubview(loginBGImage)
        
        
        
        loginView.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 10).isActive = true
        loginView.rightAnchor.constraint(equalTo:view.rightAnchor, constant: -10).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true //center it horizontally in the view
        
        
        loginStackView.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 10).isActive = true
        loginStackView.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 10).isActive = true
        loginStackView.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -10).isActive = true
        loginStackView.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -10).isActive = true
        
    
        loginBGImage.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
        loginBGImage.leftAnchor.constraint(equalTo: loginView.leftAnchor).isActive = true
        loginBGImage.rightAnchor.constraint(equalTo: loginView.rightAnchor).isActive = true
        loginBGImage.bottomAnchor.constraint(equalTo: loginView.bottomAnchor).isActive = true
        
        
        loginBackgroundView.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
        loginBackgroundView.leftAnchor.constraint(equalTo: loginView.leftAnchor).isActive = true
        loginBackgroundView.rightAnchor.constraint(equalTo: loginView.rightAnchor).isActive = true
        loginBackgroundView.bottomAnchor.constraint(equalTo: loginView.bottomAnchor).isActive = true
        
        
        
        
        //loginStackView.backgroundColor = .white
        loginStackView.addArrangedSubview(usernameTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(switchToSignupButton)
        loginStackView.addArrangedSubview(fBLoginButton)
        loginStackView.addArrangedSubview(signAnonymouslyButton)
        
        loginStackView.axis = .vertical
        loginStackView.spacing = 5
        loginStackView.distribution = .fillProportionally
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        loginStackView.setCustomSpacing(20, after: switchToSignupButton) //adds a space after switchToSignupButton
        
        loginStackView.leftAnchor.constraint(equalTo:loginView.leftAnchor, constant: 10).isActive = true
        loginStackView.rightAnchor.constraint(equalTo:loginView.rightAnchor, constant: -10).isActive = true
        loginStackView.heightAnchor.constraint(equalToConstant: loginView.frame.height / 1.5).isActive = true
        loginStackView.centerYAnchor.constraint(equalTo: loginView.centerYAnchor).isActive = true //center it horizontally

        
        
//
//        loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor, constant: 10).isActive = true
//        loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor, constant: -10).isActive = true
//        loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
//        loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true //center it horizontally
//
//        usernameTextField.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant: 20).isActive = true
//        usernameTextField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant: 10).isActive = true
//        usernameTextField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant: -10).isActive = true
//        usernameTextField.heightAnchor.constraint(equalToConstant:30).isActive = true
//
//        passwordTextField.topAnchor.constraint(equalTo:usernameTextField.bottomAnchor, constant: 10).isActive = true
//        passwordTextField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant: 10).isActive = true
//        passwordTextField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant: -10).isActive = true
//        passwordTextField.heightAnchor.constraint(equalToConstant:30).isActive = true
//
//
//        loginButton.topAnchor.constraint(equalTo:passwordTextField.bottomAnchor, constant: 10).isActive = true
//        loginButton.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant: 10).isActive = true
//        loginButton.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant: -10).isActive = true
//        loginButton.heightAnchor.constraint(equalToConstant:25).isActive = true
//
//
//        switchToSignupButton.topAnchor.constraint(equalTo:loginButton.bottomAnchor, constant: 5).isActive = true
//        switchToSignupButton.centerXAnchor.constraint(equalTo: loginContentView.centerXAnchor).isActive = true //center it horizontally
//        switchToSignupButton.heightAnchor.constraint(equalToConstant:25).isActive = true
//
//
//        fBLoginButton.topAnchor.constraint(equalTo:switchToSignupButton.bottomAnchor, constant: 25).isActive = true
//        fBLoginButton.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant: 10).isActive = true
//        fBLoginButton.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant: -10).isActive = true
//        fBLoginButton.heightAnchor.constraint(equalToConstant:25).isActive = true
//
//
//        signAnonymouslyButton.topAnchor.constraint(equalTo:fBLoginButton.bottomAnchor, constant: 10).isActive = true
//        signAnonymouslyButton.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant: 10).isActive = true
//        signAnonymouslyButton.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant: -10).isActive = true
//        signAnonymouslyButton.heightAnchor.constraint(equalToConstant:25).isActive = true
    }
    
    private func createConfirmPasswordTextField() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [confirmPasswordTextField]) //create another stackview from confirmPasswordTextField
        return stackView
    }
    
    @objc func handleSignupOrLoginTapped() {
        if confirmPasswordStackView == nil {
            confirmPasswordStackView = createConfirmPasswordTextField() //call the createConfirmPasswordTextField to create another stackView for the confirmPasswordTextField
            self.loginButton.setTitle("Sign Up", for: .normal)
            if let confirmPasswordStackView = confirmPasswordStackView {
                loginStackView.insertArrangedSubview(confirmPasswordStackView, at: 2) //insert the confirmPasswordTextField after the passwordTextField
                UIView.animate(withDuration: 1.0) {
                    self.confirmPasswordStackView?.isHidden = false
                }
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: { //puts the animation
                self.confirmPasswordStackView?.isHidden = true
                self.loginButton.setTitle("Login", for: .normal)
            }) { (_) in //with a completion handler as the line below
                self.confirmPasswordStackView?.removeFromSuperview()
                self.confirmPasswordStackView = nil
            }
        }
        
    }
    
    
    
    
}//++++++++++ END OF LOGINVIEWCONTROLLER ++++++++++

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

