////
////  LoginController+Handlers.swift
////  FolledoMyCourt
////
////  Created by Samuel Folledo on 9/4/18.
////  Copyright © 2018 Samuel Folledo. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//
//extension LoginController {
//
////extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
//
//    
//// ----- HANDLE Select Profile ImageView -----------
//    @objc func handleSelectProfileImageView() {
//        
//        print("loginLogo Tapped!")
//        
//        let picker = UIImagePickerController()
//        
//        picker.delegate = self
//        picker.allowsEditing = true
//        
//        present(picker, animated: true, completion: nil)
//    }
//    
//    
////delegate method that will get the image to our app
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        //print(info)
//        print("Finished picking image. Now setting it...")
//        var selectedImageFromPicker: UIImage?
//        
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            selectedImageFromPicker = originalImage
//            
//            dismiss(animated: true, completion: nil)
//        }
//        
////now do MY MOVES WITH THE IMAGE ==================================
//        
//        if let myCourtProfilePictureImage = selectedImageFromPicker {
////            let ui = UIView.init(frame: CGRect(x: 0, y: 50, width: 320, height: 430))
//            loginLogoImageView.backgroundColor = .white
//            loginLogoImageView.image = myCourtProfilePictureImage
//            
//            
//            
//            
//            dismiss(animated: true, completion: nil) //after image is picked, dismiss vc
//            
//        }
//        
//    }
////imagePickerController DID CANCEL
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("canceled image picker")
//        dismiss(animated: true, completion: nil) //dismiss if it u cancel
//    }
//    
//    
//    
//    
//// --------------- HANDLE Register ---------------
//    @objc func handleRegister() {
//        if let name = nameTextField.text {
//            if var email = emailTextField.text { //unwrap email
//                if var password = passwordTextField.text { //unwrap password
//                    //remove white space and new lines
//                    email = email.trimmingCharacters(in: .whitespacesAndNewlines)
//                    password = password.trimmingCharacters(in: .whitespacesAndNewlines)
//                    //spinner
//                    let spinner: UIActivityIndicatorView = UIActivityIndicatorView() as UIActivityIndicatorView
//                    spinner.activityIndicatorViewStyle = .whiteLarge
//                    spinner.center = view.center
//                    self.view.addSubview(spinner)
//                    spinner.startAnimating()
//                    
//                    //create the user
//                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                        spinner.stopAnimating()
//                        if let error = error {
//                            let alert = Service.showAlert(on: self, style: .alert, title: "Signup Error", message: error.localizedDescription)
//                            self.present(alert, animated: true, completion: nil)
//                        } else { //signup was successful
//                            
//                            if let user = user { //3 //24mins
//                                let ref = Database.database().reference()
//                                let usersReference = ref.child("users").child(user.user.uid)//SC3 //23mins - 24mins this adds this particular user in the app
//                                let values = ["name": name, "email": email]
//                                usersReference.setValue(values, withCompletionBlock: { (error, ref) in
//                                    if let error = error {
//                                        let vc = Service.showAlert(on: self, style: .alert, title: "Register Error", message: error.localizedDescription)
//                                        self.present(vc, animated: true, completion: nil)
//                                    }
//                                    
//                                    print("No Error creating a user of \(user.user.uid) \(ref.description())")
//                                    
//                                    DispatchQueue.main.async {
//                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
//                                        self.present(vc, animated: true, completion: nil)
//                                    }
//                                    //                                    self.userInfo.email = email
//                                    //                                    self.userInfo.name = name
//                                    //                                    self.userInfo.uid = String(user.user.uid)
//                                    
//                                })
//                            }
//                        }
//                    }
//                } else { //no password
//                    let vc = Service.showAlert(on: self, style: .alert, title: "Missing Password", message: "Please try again")
//                    self.present(vc, animated: true, completion: nil)
//                }
//            } else { //no email
//                let vc = Service.showAlert(on: self, style: .alert, title: "Missing Email", message: "Please try again")
//                self.present(vc, animated: true, completion: nil)
//            }
//        } else { //no name
//            let vc = Service.showAlert(on: self, style: .alert, title: "Missing Name", message: "Please try again")
//            self.present(vc, animated: true, completion: nil)
//        }
//        
//    }
//    
//    //    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
//    //        let ref = FIRDatabase.database().reference()
//    //        let usersReference = ref.child("users").child(uid)
//    //
//    //        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//    //
//    //            if let err = err {
//    //                print(err)
//    //                return
//    //            }
//    //
//    //            self.dismiss(animated: true, completion: nil)
//    //        })
//    //    }
//    
//
//    
//    
//}
