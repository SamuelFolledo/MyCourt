//
//  LoginController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 8/30/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth //2 //10mins
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    var messagesController: MessagesController?
    var initialY: CGFloat!
    var offset: CGFloat!
    
    
//    var userInfo: UserInfo!
//    let userName: String = ""
//    let userUID: String = ""
    
    var imagePicker: UIImagePickerController?
    var imageAdded: Bool = false
    var imageName: String = "FolledoCourtImages1_\(NSUUID().uuidString).jpg"
    
    
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
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleShadowColor(.darkGray, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
//            Service.buttonTitleFontSize)
        button.setTitleColor(Service.buttonTitleColor, for: .normal)
        button.layer.masksToBounds = true //this enables us to have a corner radius
        button.layer.cornerRadius = Service.buttonCornerRadius
    
    //run method on tap
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
//name textField
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.keyboardType = UIKeyboardType.default
        tf.clearButtonMode = UITextField.ViewMode.always
        tf.returnKeyType = .next
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
        tf.clearButtonMode = UITextField.ViewMode.always
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
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
        tf.keyboardType = UIKeyboardType.default
        tf.clearButtonMode = UITextField.ViewMode.always
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true //secure password inputs ****
        tf.text = "Password123"
        return tf
    }()
    
//logo
    let loginLogoImageView: UIImageView = {
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
        sc.selectedSegmentIndex = 1 //to go to log in // 1 would be the register
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
        
        handleKeyboardOberservers()
        handleLogoIsTapped()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        loginRegisterSegmentedControl.selectedSegmentIndex = 1
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    
    
// ---------------------- viewDidLoad methods ------------------------------
    
    func handleLogoIsTapped(){
        //run method on tap
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(LoginController.handleSelectLoginLogoImageView))
        //enable gesture
        loginLogoImageView.isUserInteractionEnabled = true //because by default it's false
        //        imageTap.numberOfTapsRequired = 2
        loginLogoImageView.addGestureRecognizer(imageTap)
        
    }
    
//show/hide keyboard and handling the views
    func handleKeyboardOberservers(){
        self.initialY = view.frame.origin.y //to show/hide keyboard
        self.offset = -80 //to show/hide keyboard //go "up" when decreasing the Y value

        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    //        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in //to show/hide keyboard
//            self.view.frame.origin.y = self.initialY + self.offset //this gets run whenever keyboard shows, which will move the view's origin frame up
//        }
//
//        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in //to show/hide keyboard
//            self.view.frame.origin.y = self.initialY //put the view.frame.y back to its originY
//        }
    }
    
    
    func setupViews() {
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginLogoImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(facebookButton)
        view.addSubview(signAnonymouslyButton)
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        inputsViewConstraints()
        loginRegisterButtonConstraints()
        loginLogoImageViewConstraints()
        loginRegisterSegmentedControlConstraints()
        facebookButtonConstraints()
        signAnonymouslyButtonConstraints()
    }
    
    
    
    
// ---------------------- helper methods ------------------------------
    
    @objc func handleViewsOnKeyboardShowOrHide(notification: Notification) {
//        print("Keyboard will show: \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if (notification.name == UIResponder.keyboardWillShowNotification) || (notification.name == UIResponder.keyboardWillChangeFrameNotification) {
            view.frame.origin.y = -keyboardRect.height / 2
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame.origin.y = 0
        }
        
        
    }
    
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
                spinner.style = .whiteLarge
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
                        self.messagesController?.fetchCurrentUserAndSetupNavBarTitle() //ep.7 bug fix
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
    
    

    
//handleLoginRegisterChange method
    @objc func handleLoginRegisterChange() { //updates inputsContainerView when login or register is toggled
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex) //looks for the title of loginRegisterSegmentedControl thats currently selected (0:"Login", 1: "Register")
        loginRegisterButton.setTitle(title, for: UIControl.State()) //set the button's title equal to the segmentedControl's title
        
    //change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150 //having a reference to inputsContainerViewHeightAnchor allows us to change its height whenever we change the tab from register to login and vice versa //if selectedSegmentIndex is 0, then heightAnchor is 100, else 150
        
    //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false //turn it off first then turn it back on once u update it
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3) //if selectedSegment index is 0, then nameTextFieldHeight is 0 else it's 1/3 of inputsContainerView
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 //textField isHidden = true if loginRegisterSegmentedControl.selectedSegmentIndex == 0 is true as well //hide the nameTextField's placeholder
        
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
        facebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func loginRegisterSegmentedControlConstraints() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true //put it above
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func loginLogoImageViewConstraints() {
        loginLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLogoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true //negative constant to have it on the top
        loginLogoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginLogoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
        //nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
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
    
    
    
// ----------------- HANDLE Select Profile ImageView ---------------
    @objc func handleSelectLoginLogoImageView() {
        
        print("login logo tapped")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true //will allow us to edit image
        
        picker.sourceType = .photoLibrary
//        picker.sourceType = isCamera == true ? .camera : .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
//delegate method that will get the image to our app
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        //info was updated in Swift 4
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
            
            
        }
        
        if let myCourtProfilePictureImage = selectedImageFromPicker { //if image is successfully unwrapped...
            print("putting image to login logo")
            loginLogoImageView.image = myCourtProfilePictureImage
        }
        
// These are pre Swift 4.2
//        //print(info)
//        print("Finished picking image. Now setting it...")
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            selectedImageFromPicker = originalImage
//        }

//        if let myCourtProfilePictureImage = selectedImageFromPicker {
//            //            let ui = UIView.init(frame: CGRect(x: 0, y: 50, width: 320, height: 430))
//            //loginLogoImageView.backgroundColor = .white
//            print("putting image to login logo")
//            loginLogoImageView.image = myCourtProfilePictureImage
//
//        }
//
//        dismiss(animated: true, completion: nil) //after image is picked, dismiss vc
//
    }
//imagePickerController DID CANCEL
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled image picker")
        dismiss(animated: true, completion: nil) //dismiss if it u cancel
    }
    
    
    
    
// --------------- HANDLE Register ---------------
    
//registerUserIntoDatanase
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject] ) {
        
        let ref = Database.database().reference() //https://console.firebase.google.com/u/1/project/folledomycourt/authentication/users
        let usersReference = ref.child("users").child(uid)//SC3 //23mins - 24mins this adds this particular user in the app //uid parameter was added, but remember to take and unwrap it first from whoever's gonna call this method and have it as its uid parameter
//        let values = ["name": name, "email": email, "profileImageURL": metadata.downloadUrl()] //"profileImageURL": metadata.downloadUrl() was added for the image, and added as one of the parameters instead
        usersReference.setValue(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                let vc = Service.showAlert(on: self, style: .alert, title: "Register Error", message: error.localizedDescription)
                self.present(vc, animated: true, completion: nil)
            }
        
            DispatchQueue.main.async { //if no error then proceed
                
//                self.messagesController?.fetchCurrentUserAndSetupNavBarTitle() //ep.7 bug fix
//                self.messagesController?.navigationItem.title = values["name"] as? String //ep.7 bug fix another way instead of calling method //removed as well in ep.7
                let user = MyCourtUser(dictionary: values) //ep.7
//                user.setValuesForKeys(values) //ep.7
                self.messagesController?.setupNavBarWithCurrentUser(user: user) //ep.7
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                self.present(vc, animated: true, completion: nil)
            }
//                                    self.userInfo.email = email
//                                    self.userInfo.name = name
//                                    self.userInfo.uid = String(user.user.uid)
            
        })
        
        
    }
    
    
    @objc func handleRegister() {
        if let name = nameTextField.text {
            if var email = emailTextField.text { //unwrap email
                if var password = passwordTextField.text { //unwrap password
                    //remove white space and new lines
                    email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                    //spinner
                    let spinner: UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
                    spinner.style = .whiteLarge
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
                            
                            if let userUid = user?.user.uid { //3 //24mins
                                
                                
                                
                                
                                
//BEGINNING OF STORING IMAGE TO FIREBASE STORAGE
                                let imageName = NSUUID().uuidString //create a random generated string
                                let imageReference = Storage.storage().reference().child("profile_images").child("0000\(imageName).png")
//                                if let uploadData = UIImagePNGRepresentation(self.loginLogoImageView.image!) { //removed and changed to JPEG in order to compress
                                if let profileImage = self.loginLogoImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) { //ep.7 compress the image uploaded to 10%
                                    
                                    imageReference.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                        if let error = error { //error in putting image to Storage
                                            Service.presentAlert(on: self, title: "Error Putting Data To Server", message: (error.localizedDescription))
                                            return
                                        } else { //if no error then downloadURL of metadata
                                        
//                                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                            imageReference.downloadURL(completion: { (imageUrl, error) in
                                                if let error = error {
                                                    Service.presentAlert(on: self, title: "Error in downloading image URL", message: error.localizedDescription)
                                                } else { //no error on downloading metadata URL
                                                    
                                                    if let profileImageUrl = imageUrl?.absoluteString {
                                                    
                                                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl] //"profileImageURL": metadata.downloadUrl() was added for the image, and added as one of the parameters instead
                                                    
                                                        self.registerUserIntoDatabaseWithUID(uid: userUid, values: values as [String : AnyObject])
                                                    
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
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
    
    
    
    


}

extension UIColor {
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
