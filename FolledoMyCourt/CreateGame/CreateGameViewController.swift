//
//  CreateGameViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase

class CreateGameViewController: UIViewController {
    
    @IBOutlet weak var bluetoothButton: UIBarButtonItem!
    
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var bottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .black
//        navigationItem.title = "Create Game"
        handlePushNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlertNotification()
    }
    
    
//handlePushNotifications
    func handlePushNotifications() {
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") { //Percival S18-L225 //6mins
            var request = URLRequest(url: url) //Percival S18-L225 //6mins
            request.allHTTPHeaderFields = ["Content-Type":"application/json", "Authorization":"key=AAAA9D4ABe4:APA91bFNVXujcU0BO8Wij8l0QjBVCh1YCvVxnIqZVKgfwIgGeCY0dn-M89cFPP9wIGVr7f49cXZVcsVl4YMpqW78PXPVSa_PGzC7v0MH7_lUbPQjyxNChis7YNvcZTwIIPf3zuFnJlv0jHzYLa9PGv1rPkhjl7hbJQ"] //Percival S18-L225 //6-8mins now we can take this request object and set some header fields //can get the value by first "key=....." then go "Authorization" from Project Settings -> Cloud Messaging -> and copy paste Server Key
            request.httpMethod = "POST" //Percival S18-L225 //8mins next thing to do for request is to whether it's a get or post
            request.httpBody = "{\"to\":\"fj2tQBdQ1JI:APA91bFmMkJ3uoXZ9s6eeG4xJXXsP5G4k0gKe9rw67b_RdlxrjprOqFLrW_ehtJw5dS-XvMmEQpIkbHkkRkKWQIjV_Y0eoOlvSys1rN29mwWS9AtqCOuWwEXEixDE_mJlxu7Ac6K67jRwVj1lWIVPF07L_a6EdldYw\",\"notification\":{\"title\":\"THIS IS FROM HTTP!\"}}".data(using: .utf8) //Percival S18-L225 //8-11mins now set what goes on in the body. Parsing in JSON requires this "{\"to\":\"tokenNumber\"}" backlash in order to escape the "\ \" string error not including the entire string. What we need is who we're sending it to, and provide their token, and lastly the notification we're sending
            
            URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in //Percival S18-L225 //11-13mins create the request with a completion handler
                
                if error != nil { //Percival S18-L225 //13mins
                    print(error) //Percival S18-L225 /13mins
                    let vc = Service.showAlert(on: self, style: .alert, title: "Error", message: error?.localizedDescription)
                    self.present(vc, animated: true, completion: nil)
                }
                }.resume() //Percival S18-L225 //15mins
            
        }
    }
    
    
    func displayAlertNotification() {
        let maleButton = UIAlertAction(title: "Male", style: .default, handler: maleHandler)
        let femaleButton = UIAlertAction(title: "Female", style: .default, handler: maleHandler)
        let genderAlert: UIAlertController = Service.showAlert(on: self, style: .alert, title: "Welcome to Creating a Game", message: "Are you Male Or Female?", actions: [maleButton, femaleButton], completion: nil)
        
        self.present(genderAlert, animated: true, completion: nil)
        return
    }

    func maleHandler (_: UIAlertAction) {
        Analytics.setUserProperty("Male", forName: "gender_male")
    }
    
    func femaleHandler (_: UIAlertAction) {
        Analytics.setUserProperty("Female", forName: "gender_female")
    }
    
    @IBAction func bluetoothTapped(_ sender: Any) {
        print("Bluetooth tapped!")
        self.performSegue(withIdentifier: "bluetoothSegue", sender: nil)
    }
 
    @IBAction func topButtonTapped(_ sender: Any) {
        print("Top tapped")
    }
    
    @IBAction func bottomButtonTapped(_ sender: Any) {
        print("Bottom tapped!")
    }
    
    
}
