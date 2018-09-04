//
//  LoginViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//


import UIKit
import FirebaseAuth //2 //10mins
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
        
    
    
    let screenSize: CGRect = UIScreen.main.bounds
    var signupMode = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var switchToSignupButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var signinAnonymously: UIButton!
    
    
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        facebookButton.readPermissions = ["public_profile", "email"]
        facebookButton.delegate = self
        
        
        
        
    }
    
//signInAnonymouslyButtonTapped method
    @IBAction func handleSignInAnonymouslyButtonTapped() {
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                print("Failed to sign in anonymously with error: ",error)
                let alert = Service.showAlert(on: self, style: .alert, title: "Sign In Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let user = user {
                print("+++++++++Successfully signed in anoynmously with: \(user.user)+++++++++")
//            self.dismiss(animated: true, completion: nil)
                let viewController: UIViewController = UIStoryboard(name: "HomeMap", bundle: nil).instantiateViewController(withIdentifier: "HomeMapViewController")
                self.present(viewController, animated: true, completion: nil)
//                self.performSegue(withIdentifier: "loginToMainTabSegue", sender: nil)
            }
        }
        
    }
    
    
//Facebook loginButtonDidLogOut delegate method //handles Facebook Log out Button
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { //FBLogin //17mins
        print("Did logout of Facebook...") //FBLogin //17mins
    } //FBLogin //17mins
    
//Facebook didCompleteWith delegate method
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) { //FBLogin //17mins
        if error != nil { //FBLogin //17mins
//            print(error) //FBLogin //17mins
            let alert:UIAlertController = Service.showAlert(on: self, style: .alert, title: "Facebook Login Error", message: "\(error.localizedDescription)\nPlease try again")
            self.present(alert, animated: true, completion: nil)
            return //FBLogin //17mins
        } else if result.isCancelled { //FBLogin //17mins if user canceled login
            print("User has canceled login")
            let alert:UIAlertController = Service.showAlert(on: self, style: .alert, title: "Facebook Login Error", message: "User has cancelled Login\nPlease try again")
            self.present(alert, animated: true, completion: nil)
        } else { //FBLogin //if successful, meaning no error, and login didnt cancel log in
            if result.grantedPermissions.contains("email"){ //FBLogin //18minsmake sure they gave us permissions
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) { //FBLogin //19mins //FBSDKGraohRequest - represents a request to the Facebook Graph API. //we're looking for "me" only because we dont want anything to do with user's friends. //' parameters: ["fields":"email,name"] ' gives us the email and name
                    graphRequest.start { (connection, result, error) in //FBLogin //20mins, give us connection, result, and error
                        if error != nil { //FBLogin //20mins
                            print(error!) //FBLogin //20mins
                            let alert:UIAlertController = Service.showAlert(on: self, style: .alert, title: "Facebook Login Error", message: "\(error!.localizedDescription)")
                            self.present(alert, animated: true, completion: nil)
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
    
    
    

    
//    private func createConfirmPasswordTextField() -> UIStackView {
//        let stackView = UIStackView(arrangedSubviews: [confirmPasswordTextField]) //create another stackview from confirmPasswordTextField
//        return stackView
//    }
    
    @IBAction func handleSignupOrLoginTapped() {
        
        if signupMode { //IF TRUE THEN LOGIN
            signupMode = false
            UIView.animate(withDuration: 1.0) {
                //self.confirmPasswordStackView?.isHidden = false
                self.confirmPasswordTextField.isHidden = true
            }
            self.loginButton.setTitle("Log in", for: .normal)
            self.switchToSignupButton.setTitle("Switch to Log in", for: .normal)
            
            
        } else { //IF FALSE THEN SIGN UP
            signupMode = true
            UIView.animate(withDuration: 1.0) {
                self.confirmPasswordTextField.isHidden = false
            }
            self.loginButton.setTitle("Sign Up", for: .normal)
            self.switchToSignupButton.setTitle("Switch to Log in", for: .normal)
        }
    }
    
//
//    private func setupAdBanner() {
//        self.adBannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
//        //self.adBannerView.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(adBannerView)
//
//
//        self.adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //AdMob //8mins
//        self.adBannerView.rootViewController = self //AdMob //8min s
//        self.adBannerView.load(GADRequest()) //AdMob //9mins
//
////
////        adBannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true
////        adBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        adBannerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
////        adBannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
//    }
    
    @IBAction func loginOrSignupTapped(_ sender: Any) {
        
        if let email = emailTextField.text { //unwrap email
            if let password = passwordTextField.text { //unwrap password
                
                if signupMode { //SIGNUP!
                    if passwordTextField.text != confirmPasswordTextField.text { //passwords dont match!
                        let alert:UIAlertController = Service.showAlert(on: self, style: .alert, title: "Passwords Error", message: "Passwords do not match.\nPlease try again")
                        self.present(alert, animated: true, completion: nil)
                    } else { //PASSWORDS MATCH!
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            if let error = error {
                                let alert = Service.showAlert(on: self, style: .alert, title: "Signup Error", message: error.localizedDescription)
                                self.present(alert, animated: true, completion: nil)
                            } else { //signup was successful
                                
                                if let user = user { //3 //24mins
                                    Database.database().reference().child("users").child(user.user.uid).child("email").setValue(user.user.email) //SC3 //23mins - 24mins //first name that we want is "users". Then give it a child of the user's uid (unique identifier), then we specify what their child is so give it a child "email" and set its value by the user's email //In short, this adds this particular user in the app
                                    self.dismiss(animated: true, completion: nil)
                                    //self.performSegue(withIdentifier: "loginToMainTabSegue", sender: nil)
                                }
                            }
                        }
                    }
                } else { //if not signupMode then LOGIN!
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if let error = error {
                            let okAction = UIAlertAction(title: "Ok", style: .default)
                            let alert = Service.showAlert(on: self, style: .alert, title: "Login Error", message: error.localizedDescription, actions: [okAction])
                            self.present(alert, animated: true, completion: nil)
                        } else { //signup was successful
                            self.performSegue(withIdentifier: "loginToMainTabSegue", sender: nil)
                        }
                    }
                }
            }
        }
            
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
}//++++++++++ END OF LOGINVIEWCONTROLLER ++++++++++











/*
 PROGRAMATICALLY PROGRAMMED LOGINVIEWCONTROLLER

 let screenSize: CGRect = UIScreen.main.bounds
 var adBannerView = GADBannerView()
 
 
 let loginScreenStackView = UIStackView()
 let loginStackView = UIStackView()
 private var confirmPasswordStackView: UIStackView?
 
 let appLogoView: UIView = {
 let view = UIView()
 view.backgroundColor = .gray
 view.translatesAutoresizingMaskIntoConstraints = false
 return view
 }()
 
 let loginView: UIView = {
 let loginView = UIView()
 loginView.backgroundColor = .clear
 loginView.translatesAutoresizingMaskIntoConstraints = false
 return loginView
 }()
 
 let loginBackgroundView: UIView = {
 let bgView = UIView()
 bgView.backgroundColor = .clear
 bgView.translatesAutoresizingMaskIntoConstraints = false
 return bgView
 }()
 
 
 private let usernameTextField: UITextField = {
 let textField = UITextField()
 textField.keyboardType = .emailAddress
 textField.returnKeyType = .next
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
 self.navigationController?.isNavigationBarHidden = true
 
 
 setupViews()
 setupAdBanner()
 
 self.usernameTextField.delegate = self
 self.passwordTextField.delegate = self
 
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
 //            self.dismiss(animated: true, completion: nil)
 self.performSegue(withIdentifier: "mainTabBarController", sender: nil)
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
 
 
 
 //++++++++++++++++++++++++++++ SETUPVIEWS ++++++++++++++++++++++++++++
 fileprivate func setupViews() {
 view.backgroundColor = .orange
 
 //------------------------------loginScreenStackView-----------------------------------
 view.addSubview(loginScreenStackView)
 loginScreenStackView.translatesAutoresizingMaskIntoConstraints = false
 loginScreenStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
 loginScreenStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
 loginScreenStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
 loginScreenStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
 //
 //        loginScreenStackView.addArrangedSubview(appLogoView)
 //        loginScreenStackView.addArrangedSubview(adBannerView)
 //        loginScreenStackView.addArrangedSubview(loginView)
 loginScreenStackView.axis = .vertical
 loginScreenStackView.spacing = 10
 loginScreenStackView.distribution = .fill
 
 
 //------------------------------appLogoView----------------------------------------
 loginScreenStackView.addArrangedSubview(appLogoView)
 print("----------------------------------------appLogoView")
 let appLogoImageView = UIImageView(frame: self.appLogoView.bounds)
 appLogoImageView.backgroundColor = .clear
 appLogoImageView.image = UIImage(named: "apple")
 appLogoImageView.clipsToBounds = true //A Boolean value that determines whether subviews are confined to the bounds of the view
 appLogoImageView.contentMode = .scaleAspectFit //A flag used to determine how a view lays out its content when its bounds change.
 appLogoImageView.alpha = 1
 appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
 self.appLogoView.addSubview(appLogoImageView)
 
 //        appLogoView.topAnchor.constraint(equalTo: loginScreenStackView.topAnchor, constant: 10).isActive = true
 appLogoView.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
 
 //appLogoView.contentHuggingPriority(for: <#T##UILayoutConstraintAxis#>)
 //appLogoView.bottomAnchor.constraint(equalTo: loginView.topAnchor, constant: 25).isActive = true
 //appLogoView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
 //appLogoView.bottomAnchor.constraint(equalTo: self.loginView.topAnchor, constant: 10).isActive = true
 //        appLogoView.leftAnchor.constraint(equalTo:loginScreenStackView.leftAnchor, constant: 0).isActive = true
 //        appLogoView.rightAnchor.constraint(equalTo:loginScreenStackView.rightAnchor, constant: 0).isActive = true
 //appLogoView.centerXAnchor.constraint(equalTo: loginScreenStackView.centerXAnchor).isActive = true //center it in X // |--0--|
 
 appLogoImageView.topAnchor.constraint(equalTo: appLogoView.topAnchor, constant: 10).isActive = true
 appLogoImageView.bottomAnchor.constraint(equalTo: appLogoView.bottomAnchor, constant: -10).isActive = true
 
 appLogoImageView.leftAnchor.constraint(equalTo:appLogoView.leftAnchor, constant: 10).isActive = true
 appLogoImageView.rightAnchor.constraint(equalTo:appLogoView.rightAnchor, constant: -10).isActive = true
 //        appLogoImageView.centerYAnchor.constraint(equalTo: appLogoView.centerYAnchor).isActive = true
 //        appLogoImageView.centerXAnchor.constraint(equalTo: appLogoView.centerXAnchor).isActive = true
 
 
 
 
 
 //------------------------------loginView----------------------------------------
 loginScreenStackView.addArrangedSubview(loginView)
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
 
 
 
 loginView.leftAnchor.constraint(equalTo:loginScreenStackView.leftAnchor).isActive = true
 loginView.rightAnchor.constraint(equalTo:loginScreenStackView.rightAnchor).isActive = true
 loginView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
 //loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true //center it horizontally in the view
 loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
 
 
 
 
 loginBGImage.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
 loginBGImage.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 0).isActive = true
 loginBGImage.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: 0).isActive = true
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
 
 //        loginStackView.leftAnchor.constraint(equalTo:loginView.leftAnchor, constant: 10).isActive = true
 //        loginStackView.rightAnchor.constraint(equalTo:loginView.rightAnchor, constant: -10).isActive = true
 //        loginStackView.heightAnchor.constraint(equalToConstant: loginView.frame.height / 1.5).isActive = true
 //        loginStackView.centerYAnchor.constraint(equalTo: loginView.centerYAnchor).isActive = true //center it horizontally
 loginStackView.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 10).isActive = true
 loginStackView.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 0).isActive = true
 loginStackView.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: 0).isActive = true
 loginStackView.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -10).isActive = true
 
 
 
 
 
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
 
 
 private func setupAdBanner() {
 adBannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
 adBannerView.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(adBannerView)
 
 
 adBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" //AdMob //8mins
 adBannerView.rootViewController = self //AdMob //8min s
 adBannerView.load(GADRequest()) //AdMob //9mins
 
 
 adBannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true
 adBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
 adBannerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
 adBannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
 }
 
 
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 
 switch textField {
 case usernameTextField:
 textField.resignFirstResponder()
 passwordTextField.becomeFirstResponder()
 case passwordTextField:
 textField.resignFirstResponder()
 default:
 textField.resignFirstResponder()
 }
 
 return true
 }
 
 
 
 }//++++++++++ END OF LOGINVIEWCONTROLLER ++++++++++
 
*/
