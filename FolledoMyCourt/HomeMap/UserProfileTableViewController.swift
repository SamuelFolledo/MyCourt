//
//  UserProfileTableViewController
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

struct CellData {
    let image: UIImage?
    let message: String?
}





//             USER PROFILE TABLE VIEW CONTROLLER            //

class UserProfileTableViewController: UITableViewController {
    
    var data = [CellData]()
    let cellId: String = "cellId"
    var rows = 0
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
//        data = [CellData.init(image: #imageLiteral(resourceName: "apple"), message: "About")] //create a new cell
//        data = [CellData.init(image: #imageLiteral(resourceName: "exit"), message: "Logout")] //create a new cell
//
        
        createDataCell()
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        
    //but we still have to automatically make them resize to the contents inside of it
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100 //to make the cell have a limit and save memory //now in cellForRowAt layoutSubviews()
        
        
    }
    
    
   
    
    func insertRowMode3(row: Int, cell: CellData, completion: @escaping ()-> Void) {
        let indexPath = IndexPath(row: row, section: 0)
        print("cell \(row) is appending at \(indexPath)")
        data.append(cell)
        tableView.insertRows(at: [indexPath], with: .right)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion()
        }
    }
    
    
    func createDataCell() {
         
        let data1 = CellData.init(image: #imageLiteral(resourceName: "updateProfilePicture"), message: "Update Profile Picture")
        let data2 = CellData.init(image: #imageLiteral(resourceName: "exit"), message: "Logout")
        let data3 = CellData.init(image: #imageLiteral(resourceName: "apple"), message: "About")
        
        insertRowMode3(row: 0, cell: data1) {
            self.insertRowMode3(row: 1, cell: data2, completion: {
                self.insertRowMode3(row: 2, cell: data3, completion: {
                    print("Done inserting rows")
                })
            })
        }
        
//        data.append(data1)
//        data.append(data2)
//        data.append(data3)
        
//        insertRowMode3(row: 0, cell: <#T##CellData#>, completion: <#T##() -> Void#>)
        
    }
    
    
    
    @IBAction func logoutTapped() {
        perform(#selector(handleLogout), with: nil, afterDelay: 0)
        
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
    
//didSelectRow
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0:
//            handleUpdateImage()
            print("Update image coming soon")
        case 1:
            handleLogout()
        case 2:
            print("About coming soon")
        default:
            break
        }
        
    }
    
    
//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        
        cell.mainImage = data[indexPath.row].image
        cell.message = data[indexPath.row].message
        cell.layoutSubviews()
        
        return cell
    }
    
//numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    
 
    
//handleLogout
    @objc func handleLogout() {
        let signoutAction = UIAlertAction(title: "Log Out?", style: .destructive) { (action) in
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
}

