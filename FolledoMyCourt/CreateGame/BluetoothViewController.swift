//
//  BluetoothViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 8/16/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class BluetoothViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Udemy_HandlingPushes_S16L212 //10mins //once we have set up the nameLabel and rssiLabel tableViewCell outlets, we have to get the cell from out storyboard, by using DequeueReusable Cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "blueCell", for: indexPath) as? BluetoothTableViewCell {
            
            cell.nameLabel.text = "This is a test"
            cell.rssiLabel.text = "RSSI: -28"
            
            return cell
        } else {
            print("Missing cell file")
            let vc: UIAlertController = Service.showAlert(on: self, style: .alert, title: "Error", message: "Missing Cell file")
            present(vc, animated: true, completion: nil)
        }
        
        return UITableViewCell() //should never get run
        
    }
    
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
