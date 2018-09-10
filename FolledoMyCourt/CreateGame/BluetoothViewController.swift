//
//  BluetoothViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 8/16/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate {

    var names: [String] = [] //2 storage for our teble view cells
    var RSSIs: [NSNumber] = []
    var timer: Timer?
    
    
    @IBOutlet weak var tableView: UITableView!
    var centralManager: CBCentralManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Udemy_HandlingPushes_S16L212 //10mins //once we have set up the nameLabel and rssiLabel tableViewCell outlets, we have to get the cell from out storyboard, by using DequeueReusable Cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "blueCell", for: indexPath) as? BluetoothTableViewCell {
            
            cell.nameLabel.text = names[indexPath.row]
            cell.rssiLabel.text = "RSSI: \(RSSIs[indexPath.row])"
            
            return cell
        } else {
            print("Missing cell file")
            let vc: UIAlertController = Service.showAlert(on: self, style: .alert, title: "Error", message: "Missing Cell file")
            present(vc, animated: true, completion: nil)
        }
        
        return UITableViewCell() //should never get run
        
    }
    
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        startScan()
        startTimer()
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            self.startScan()
        })
    }
    
    func startScan() {
        names = [] //empty the array and reload it
        RSSIs = []
        tableView.reloadData()
        
        centralManager?.stopScan() //stop and start it again
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    
//centralManagerDidUpdateState
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn { //.poweredOff , .poweredOn , .resetting , .unauthorized , .unknown , .unsupported
            startScan()
            startTimer()
            
        } else { //if blue tooth snt working
            Service.presentAlert(on: self, title: "Bluetooth isn't working", message: "Make sure your bluetooth is on and ready to rock and roll!")
        }
    }
    
//func called for bluetooththat didDidscover a device
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("\n\n\n**************************************************\n")
        
        if let bluetoothPeripheralName = peripheral.name {
            print("Peripheral Name: \(bluetoothPeripheralName)")
            names.append(bluetoothPeripheralName)
        } else {
            print("Peripheral 'Name': \(peripheral.identifier.uuidString)")
            names.append(peripheral.identifier.uuidString) //if it cant get an actual name then just give me any information about how u could identify each of those
        }
        
        print("Peripheral NamE: \(RSSI)")
        RSSIs.append(RSSI)
        
        print("Ad Data: \(advertisementData)")
        print("\n**************************************************\n\n\n")
            
        
    }
    
    
}
