//
//  LoginController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 8/30/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth //2 //10mins
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

//    var userInfo: UserInfo!
//    let userName: String = ""
//    let userUID: String = ""
    
    let facebookButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }() //FBLogin //12mins
    
    lazy var signAnonymouslyButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Sign in Anonymously", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.backgroundColor = .black
        button.layer.masksToBounds = true //this enables us to have a corner radius
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.addTarget(self, action: #selector(handleSignInAnonymouslyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//inputs view
    let inputsContainerView: UIView = { //view for our inputs
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false //needed to have constraints programmatically
        view.layer.cornerRadius = 5 //set corner radius to 5
        view.layer.masksToBounds = true //needed to set corner radius
        return view
    }()
//loginRegister button
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleShadowColor(.darkGray, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
//            Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.layer.masksToBounds = true //this enables us to have a corner radius
        button.layer.cornerRadius = Service.buttonCornerRadius
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
//name textField
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor (r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//email textField
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "samuelfolledo@gmail.com"
        tf.keyboardType = .emailAddress
        return tf
    }()
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor (r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//password textField
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true //secure password inputs ****
        tf.text = "Password123"
        return tf
    }()
//logo
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//loginRegisterSegmentedControl
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        //sc.selectedSegmentIndex = 0 //to go to log in // 1 would be the register
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    
// -------------------- VIEW DID LOAD ------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r:61, g:91, b:151)
        setupViews()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        facebookButton.readPermissions = ["public_profile", "email"]
        facebookButton.delegate = self
        
        //loginRegisterSegmentedControl.selectedSegmentIndex = 0
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginRegisterSegmentedControl.selectedSegmentIndex = 0
    }

    func setupViews() {
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(facebookButton)
        view.addSubview(signAnonymouslyButton)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        inputsViewConstraints()
        loginRegisterButtonConstraints()
        logoImageViewConstraints()
        loginRegisterSegmentedControlConstraints()
        facebookButtonConstraints()
        signAnonymouslyButtonConstraints()
    }
    
// ---------------------- Facebook methods ------------------------------
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
            } else { //result.grantedPermissions = false
                let alert:UIAlertController = Service.showAlert(on: self, style: .alert, title: "Facebook Error", message: "Facebook failed to grant access")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
// ---------------------- methods ------------------------------
    
//signInAnonymouslyButtonTapped method
    @objc func handleSignInAnonymouslyButtonTapped() {
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                print("Failed to sign in anonymously with error: ",error)
                let vc = Service.showAlert(on: self, style: .alert, title: "Sign In Error", message: error.localizedDescription)
                self.present(vc, animated: true, completion: nil)
                return
            } else { //if no error unwrapped = signInAnonymously successfuly
                print("Successfully signed in anoynmously with: \(String(describing: user?.user))")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        
        if var email = emailTextField.text { //unwrap email
            if var password = passwordTextField.text {
            //remove white space and new lines
                email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            //spinner
                let spinner: UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
                spinner.activityIndicatorViewStyle = .whiteLarge
                spinner.center = view.center
                self.view.addSubview(spinner)
                spinner.startAnimating()
                
            //signin
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    spinner.stopAnimating() //stop spinner
                    if let error = error {
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        let alert = Service.showAlert(on: self, style: .alert, title: "Login Error", message: error.localizedDescription, actions: [okAction])
                        self.present(alert, animated: true, completion: nil)
                    } else { //login was successful
                        
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func handleRegister() {
        if let name = nameTextField.text {
            if var email = emailTextField.text { //unwrap email
                if var password = passwordTextField.text { //unwrap password
                //remove white space and new lines
                    email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                //spinner
                    let spinner: UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
                    spinner.activityIndicatorViewStyle = .whiteLarge
                    spinner.center = view.center
                    self.view.addSubview(spinner)
                    spinner.startAnimating()
                    
                //create the user
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        spinner.stopAnimating()
                        if let error = error {
                            let alert = Service.showAlert(on: self, style: .alert, title: "Signup Error", message: error.localizedDescription)
                            self.present(alert, animated: true, completion: nil)
                        } else { //signup was successful
                            
                            if let user = user { //3 //24mins
                              let ref = Database.database().reference()
                                let usersReference = ref.child("users").child(user.user.uid)//SC3 //23mins - 24mins this adds this particular user in the app
                                let values = ["name": name, "email": email]
                                usersReference.setValue(values, withCompletionBlock: { (error, ref) in
                                    if let error = error {
                                        let vc = Service.showAlert(on: self, style: .alert, title: "Register Error", message: error.localizedDescription)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                    
                                    print("No Error creating a user of \(user.user.uid) \(ref.description())")
                                    
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                                        self.present(vc, animated: true, completion: nil)
                                    }
//                                    self.userInfo.email = email
//                                    self.userInfo.name = name
//                                    self.userInfo.uid = String(user.user.uid)
                                    
                                })
                            }
                        }
                    }
                } else { //no password
                    let vc = Service.showAlert(on: self, style: .alert, title: "Missing Password", message: "Please try again")
                    self.present(vc, animated: true, completion: nil)
                }
            } else { //no email
                let vc = Service.showAlert(on: self, style: .alert, title: "Missing Email", message: "Please try again")
                self.present(vc, animated: true, completion: nil)
            }
        } else { //no name
            let vc = Service.showAlert(on: self, style: .alert, title: "Missing Name", message: "Please try again")
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
//handleLoginRegisterChange method
    @objc func handleLoginRegisterChange() { //updates inputsContainerView when login or register is toggled
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex) //looks for the title of loginRegisterSegmentedControl thats currently selected (0:"Login", 1: "Register")
        loginRegisterButton.setTitle(title, for: UIControlState()) //set the button's title equal to the segmentedControl's title
        
    //change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150 //having a reference to inputsContainerViewHeightAnchor allows us to change its height whenever we change the tab from register to login and vice versa //if selectedSegmentIndex is 0, then heightAnchor is 100, else 150
        
    //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false //turn it off first then turn it back on once u update it
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3) //if selectedSegment index is 0, then nameTextFieldHeight is 0 else it's 1/3 of inputsContainerView
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 //hide the nameTextField's placeholder
        
    //change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false //turn it off first then turn it back on once u update it
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3) //emailTextField's Height will be 1/2 of inputsContainer if selectedSegmentIndex is 0, else height will be 1/3
        emailTextFieldHeightAnchor?.isActive = true
        
    //change topAnchor of emailTextField
        emailTextFieldTopAnchor?.isActive = false
        emailTextFieldTopAnchor = emailTextField.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?inputsContainerView.topAnchor : nameTextField.bottomAnchor)
        emailTextFieldTopAnchor?.isActive = true
        
    //change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false //turn it off first then turn it back on once u update it
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
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
    
    
    
// ---------------------- set ups / constraints --------------------
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint? //will change between 100 or 150 depending on the loginRegisterSegmentedControl
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldTopAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func signAnonymouslyButtonConstraints() {
        signAnonymouslyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signAnonymouslyButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        signAnonymouslyButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        signAnonymouslyButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func facebookButtonConstraints() {
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.topAnchor.constraint(equalTo: signAnonymouslyButton.bottomAnchor, constant: 12).isActive = true
        facebookButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    
    func loginRegisterSegmentedControlConstraints() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true //put it above
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 1/2).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func logoImageViewConstraints() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true //negative constant to have it on the top
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    func loginRegisterButtonConstraints() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
//inputs constraints
    func inputsViewConstraints() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        self.inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150) //this will allow us to interchange the heighAnchor
        self.inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
    //nameTextField
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    //nameSeparatorView constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.bottomAnchor.constraint(equalTo: emailTextField.topAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    //emailTextField
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3) //emailTextFieldHeightAnchor
        emailTextFieldHeightAnchor?.isActive = true
        
    //emailSeparatorView constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 0).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3) //passwordTextFieldHeightAnchor
        passwordTextFieldHeightAnchor?.isActive = true
    }


}

extension UIColor {
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

