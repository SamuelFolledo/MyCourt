//
//  ChatInputContainerView.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 10/4/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView { //ep.23 3mins inputContainerView refactored
    
    let sendButton = UIButton(type: .system) //ep.23 13mins
    
    var chatLogController: ChatLogController? { //ep.23 11mins reference so we can call handleSend //ep.23 12mins in order to call a selector handleSend on an object that is different than self,
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside) //ep.23 13mins this will now allow us to call handleSend method from ChatLogController
            
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap))) //ep.23 15mins we can also add a gesture like adding a target
        }
    }
    
    let uploadImageView: UIImageView = { //ep.23 17mins
        let uploadImageView = UIImageView() //ep.17 4mins //ep.23 15mins created a reference
        uploadImageView.image = UIImage(named: "photoAlbum") //ep.17 4mins
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false //ep.17 5mins
        uploadImageView.isUserInteractionEnabled = true //ep.17 8mins
//        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap))) //ep.17 6mins //ep.23 moved to chatLogController() didSet during refactoring
        return uploadImageView
    }()
    
    let inputTextField: UITextField = { //ep.8
        let tf = UITextField() //ep.8
        tf.keyboardType = UIKeyboardType.default
        tf.clearButtonMode = UITextField.ViewMode.unlessEditing
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.delegate = self //gotta declare it at viewDidLoad
        return tf
    }()
    
    
//initializer
    override init(frame: CGRect) { //ep.23 3mins
        super.init(frame: frame) //ep.23 3mins
        backgroundColor = .white
        
    //pasted at ep.23 6mins
        addSubview(uploadImageView) //ep.17 4mins
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true //ep.17 5mins
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true //ep.17 5mins
        uploadImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true //ep.17 5mins
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        //sendButton
        //let sendButton = UIButton(type: .system) //type: .system makes the button look more clickable //ep.8 //ep.23 13mins we created a reference for it instead
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside) //how can we call handleSend method from ChatLogController
        addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        //inputTextField //sendButton, input textField, and separator line is copy pasted from setupInputComponents at ep.15 21mins
        addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 5).isActive = true //ep.17 6mins updated to constraint it to the uploadImage
        self.inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        //separatorLineView
        let separatorLineView = UIView() //ep.8
        separatorLineView.backgroundColor = .gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //ep.8 //ep.23 18mins refactored and was moved to ChatInputContainerView class
        chatLogController?.handleSend() //ep.23 18mins
        return true
    }
    
    required init?(coder aDecoder: NSCoder) { //ep.23 4mins
        fatalError("init(coder:) has not been implemented") //ep.23 4mins
    }
    
    
}
