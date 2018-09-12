//
//  ChatLogController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/10/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ChatLogController: UICollectionViewController, UITextFieldDelegate { //ep.8 dont forget to call ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    
    var user: MyCourtUser? { //ep.9 added so we can give it a value from the newMessagesController
        didSet {
            navigationItem.title = user?.name //ep.9 7mins
        }
    }
    
    let inputTextField: UITextField = { //ep.8
        let tf = UITextField() //ep.8
        tf.keyboardType = UIKeyboardType.default
        tf.clearButtonMode = UITextFieldViewMode.unlessEditing
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.delegate = self //gotta declare it at viewDidLoad
        return tf
    }()
    
    
//VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        inputTextField.delegate = self //ep.8
        
        
        
        setupInputComponents() //ep.8
        
    }
    
    
    func setupInputComponents() { //ep.8
        let containerView = UIView() //ep.8
//        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView) //ep.8
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    //sendButton
        let sendButton = UIButton(type: .system) //type: .system makes the button look more clickable //ep.8
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
    //inputTextField
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
    //separatorLineView
        let separatorLineView = UIView() //ep.8
        separatorLineView.backgroundColor = .gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
    }
    

//sending message
    @objc func handleSend() { //ep.8 20mins
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId() //create a child reference
        
        let userUid = user!.userUid  //ep.9 //the user we will be sending to
        let fromId = Auth.auth().currentUser!.uid //ep.9
        let timeStamp:Int = Int(Date().timeIntervalSince1970) //ep.9
        let values = ["text": inputTextField.text!, "userUid": userUid!, "fromId": fromId, "timeStamp": timeStamp] as [String : Any] //ep.9
//        let values = ["text": inputTextField.text!, "users": user!.name!] as [String : Any] //ep.9 //"users": user!.name! is not a good idea because changing your name will require us to manually change the name in our database, which is ineffective
        
        childRef.updateChildValues(values)
        
        print("Text is... \(String(describing: inputTextField.text))")
    }
    
    
    
    
    
//textFieldShouldReturn called //ep.8
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //ep.8
        handleSend()
        return true
    }
    
    
}
