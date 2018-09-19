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


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout { //ep.8 dont forget to call ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()) //ep.12 UICollectionViewDelegateFlowLayout is added
    
    let cellId:String = "cellId"
    var messages = [ChatMessage]()

    var user: MyCourtUser? { //ep.9 added so we can give it a value from the newMessagesController
        didSet {
            navigationItem.title = user?.name //ep.9 7mins
            
            observeMessages() //ep.12 12mins
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

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0) //ep.13 gives it a padding
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0) //ep.24mins give scrollIndicatorInsets a padding to so it wont look weird, they go together with collectionView?.contentInset
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true //ep.12 27mins will make our collection view have a scrollable feel
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId) //ep.12 register the cell
        
        inputTextField.delegate = self //ep.8
        
        
        
        
        setupInputComponents() //ep.8
        
        handleKeyboardOberservers()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //ep.12
        return messages.count //ep.12
    }
    
    
//cellForRowAt
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //ep.12
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell //ep.12 //as! ChatMessageCell is added at 22mins
//        cell.backgroundColor = .blue
        
        let message = messages[indexPath.item] //ep.12 26mins
        cell.textView.text = message.text //ep12 26mins
        
        setupCell(cell: cell, message: message) //ep.14 6mins //setup the bubbleView's background color to blue or gray
        
    //ep.13 14mins before returning, make sure bubbleView's width is modified properly
        //cell.bubbleWidthAnchor?.constant = 50 //ep.13 16mins grab the cell's bubbleWidthAnchor optional var
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32 //ep.13 16mins with the estimateFrameForText(text: String) method, we can even use it and equal it to a cell's bubbleWidthAnchor.constant *** MIND BLOWN!!! ***
//        cell.bubbleWidthAnchor?.isActive = true
        
        
        return cell //ep.12
    }
    
//collectionView size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80 //ep.13 7mins added to adot to textView's height
        
        //ep.13 9mins before we can call estimeFrameForText(text:), we need to unwrap first
        if let text = messages[indexPath.item].text { //ep.13 10mins get the text item of messages
            height = estimateFrameForText(text: text).height + 20 //ep.13 10mins
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect { //ep.13 8mins
        let size = CGSize(width: 200, height: 1000) //ep13 8mins
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) //ep.13 9mins this is how you would use this NSStringDrawingOptions
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)], context: nil) //ep13 7mins boundingRect for NSString which gives us the estimated frame of the entire textblock
        
    }
    
    
//viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { //ep.13 25mins this method gets called everytime the screen changes size, or rotate
        collectionView?.collectionViewLayout.invalidateLayout() //ep.13 25mins if we call this method, it will rerender the collectionView layout paramters //nvalidates the current layout and triggers a layout update
    }
    
    
//setupCell ep.14 6mins
    private func setupCell(cell: ChatMessageCell, message: ChatMessage) { //ep.14 6mins
        
        if let profileImageUrl = self.user?.profileImageUrl { //ep.14 17mins self.user is the MyCourtUser the current user is chatting with and grab its url
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl) //ep.14 17mins this gives us the user we're chatting with's profileImage
        }
        
        if message.fromId == Auth.auth().currentUser?.uid { //ep.14 3mins to figure out which message is the gray bubble, check if the fromId is the same as the current user
            //ep14 3mins outgoing is blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor //ep.14 5mins
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true //ep.14 15mins hide the profileImageView when bubbleView is blue
            cell.bubbleViewRightAnchor?.isActive = true //ep.14 16mins
            cell.bubbleViewLeftAnchor?.isActive = false //ep.14 16mins
            
        } else { //ep14 3mins incoming gray messages
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = .black //ep.14 3mins
            
            cell.bubbleViewRightAnchor?.isActive = false //ep.14 14mins turn off the right anchor so the bubble would go to the left instead
            cell.bubbleViewLeftAnchor?.isActive = true //ep.14 14mins
            cell.profileImageView.isHidden = false  //ep.14 make the pic come out
        }
        
    }
    
//observe messages method
    func observeMessages() { //ep.12 13mins
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid) //ep.12
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in //ep.12 //make sure you observe, not observeSingleEvent
//            print(snapshot) //ep.12 this shows us all the reference for the current user's messages. But now we have to fetch each messages from the reference from snapshot
            
            let messageId = snapshot.key //ep.12
            let messagesRef = Database.database().reference().child("messages").child(messageId) //ep.12
            messagesRef.observeSingleEvent(of: .value, with: { (snapshoot) in //ep.12 observeSingleEvent of .value
//                print(snapshoot) //ep.12
                
                guard let dictionary = snapshoot.value as? [String: AnyObject] else { return } //ep.12
                let message = ChatMessage(dictionary: dictionary) //ep.12
//                print("Message retrieved is...... \(message.text)") //ep.12 will print all of the message.text
                
                if message.chatPartnerId() == self.user?.userUid { //ep.12 27mins check if chatPartnerId is equal to our toId (user we are sending the message to) then run code block, if not dont append our messages
                    self.messages.append(message) //ep.12 18mins add message to ChatMessage //dont forget to reload data
                    DispatchQueue.main.async { //ep.12
                        self.collectionView?.reloadData() //ep.12 19mins
                        self.collectionView?.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true) //this puts the view of collectionView all the way to the bottom of the screen with the latest message
                    }
                }
                
            }, withCancel: nil) //ep.12
        }, withCancel: nil) //ep.12
        
    }
    
    
    func setupInputComponents() { //ep.8
        let containerView = UIView() //ep.8
        containerView.backgroundColor = .white
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
        
//        childRef.updateChildValues(values) //ep.9 //ep.11 added a completion block
        
        childRef.updateChildValues(values) { (error, ref) in //ep.11 updateChildValues with completion handler to not broadcast everyone's messages
            if let error = error {
                Service.presentAlert(on: self, title: "Error", message: "\(error.localizedDescription)")
                return
            }
        //if no error ep.11
            
            self.inputTextField.text = nil //ep.13 19mins clear the textfield after handling send
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId) //ep.11
            
            let messageId = childRef.key //ep.11 //ref's childByAutoId, gives us the node reference.key for when a new node is created
            userMessagesRef.updateChildValues([messageId: 1]) //ep.11 8mins this is what you call the "fanning out" of two trees/nodes and messages gets the actual message information, then this user-messages just references what's inside the message node (fromId, text, timeStamp, toId)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(userUid!)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
        
        self.inputTextField.resignFirstResponder() //put keyboard away
        
        print("Sent text is... \(String(describing: inputTextField.text))")
    }
    
    
    
//textFieldShouldReturn called //ep.8
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //ep.8
        handleSend()
//        textField.resignFirstResponder()
        
//
//        switch textField {
//        case inputTextField:
//            textField.resignFirstResponder()
//        default:
//            textField.resignFirstResponder()
//        }
        
        return true
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
//show/hide keyboard and handling the views
    func handleKeyboardOberservers(){
//        self.initialY = view.frame.origin.y //to show/hide keyboard
//        self.offset = -80 //to show/hide keyboard //go "up" when decreasing the Y value
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in //to show/hide keyboard
        //            self.view.frame.origin.y = self.initialY + self.offset //this gets run whenever keyboard shows, which will move the view's origin frame up
        //        }
        //
        //        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in //to show/hide keyboard
        //            self.view.frame.origin.y = self.initialY //put the view.frame.y back to its originY
        //        }
    }
    
    @objc func handleViewsOnKeyboardShowOrHide(notification: Notification) {
        //        print("Keyboard will show: \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if (notification.name == Notification.Name.UIKeyboardWillShow) || (notification.name == Notification.Name.UIKeyboardWillChangeFrame) {
            self.view.frame.origin.y = -keyboardRect.height
        } else if notification.name == Notification.Name.UIKeyboardWillHide {
            self.view.frame.origin.y = 0
        }
        
        
    }
    
    
}
