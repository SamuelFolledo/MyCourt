//
//  UserProfileTableViewController
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        //backButton.title = "Return"
        
        
    }
    
    
    @IBAction func logoutTapped() {
        let signoutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                try Auth.auth().signOut() //Signs user out
                let cookies = HTTPCookieStorage.shared
                let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
                for cookie in facebookCookies! {
                    cookies.deleteCookie(cookie )
                }
                let loginController = LoginController()
                print("LOGGING OUTTTTTTTT")
                self.present(loginController, animated: true, completion: nil)
//                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
//                print("LOGGING OUTTTTTTTT")
//                self.present(viewController, animated: true, completion: nil)
                
            } catch let error { //present any error
                let alert = Service.showAlert(on: self, style: .alert, title: "Logout Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                //print(error)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signoutOrCancel: UIAlertController = Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signoutAction, cancelAction], completion: nil)
        self.present(signoutOrCancel, animated: true, completion: nil)
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let alert = Service.showAlert(on: self, style: .alert, title: "Save Successfuly", message: "EEEEYYOOOOOOOOO!!!", actions: [alertAction]) //an alert that dismisses the VC once OK is pressed
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellIdentifier", for: indexPath)
        return cell
    }
    
    
    
}










/*

 
 //    func setNavigationBar() {
 //        let screenSize: CGRect = UIScreen.main.bounds
 //        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 50))
 //
 //        //navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: screenSize.width, height: 44))
 //        let navItem = UINavigationItem(title: "User Profile")
 //
 //
 //        let signoutButton = UIButton()
 //        signoutButton.frame = CGRect(x:0, y:0, width:40, height:40)
 //        signoutButton.setImage(UIImage(named: "exit"), for: .normal)
 //        signoutButton.setImage(UIImage(named: "exit"), for: .highlighted)
 //        signoutButton.backgroundColor = UIColor.yellow
 //        signoutButton.layer.cornerRadius = 5.0
 //        signoutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
 //        let rightBarButton = UIBarButtonItem(customView: signoutButton)
 //        //self.navigationItem.rightBarButtonItem = rightBarButton
 //        navItem.rightBarButtonItem = rightBarButton
 //
 //        //let signoutButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(signOutButtonTapped))
 //
 //
 //        navBar.setItems([navItem], animated: false)
 //        self.view.addSubview(navBar)
 //    }
 
 
*/
