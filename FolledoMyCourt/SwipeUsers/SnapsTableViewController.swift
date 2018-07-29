//
//  SnapsTableViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/25/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class SnapsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    

//numerOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
//numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
