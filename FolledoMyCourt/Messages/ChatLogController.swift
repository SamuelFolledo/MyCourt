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
import FirebaseStorage //ep.17 12mins


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //ep.8 dont forget to call ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()) //ep.12 UICollectionViewDelegateFlowLayout is added //ep.17 8mins imagePicker an uiNavPicker are added
    
    let cellId:String = "cellId"
    var messages = [ChatMessage]()
    var containerViewBottomAnchor: NSLayoutConstraint? //ep.15 6mins
    
    lazy var inputContainerView: UIView = { //ep.15 18:40mins //you cant access self unless it's a lazy var, not let/var
        let containerView = UIView() //ep.15 16mins
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50) //ep.15mins
        containerView.backgroundColor = .white
        
        
        let uploadImageView = UIImageView() //ep.17 4mins
        uploadImageView.image = UIImage(named: "photoAlbum") //ep.17 4mins
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false //ep.17 5mins
        uploadImageView.isUserInteractionEnabled = true //ep.17 8mins
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleUploadTap))) //ep.17 6mins
        containerView.addSubview(uploadImageView) //ep.17 4mins
        
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true //ep.17 5mins
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true //ep.17 5mins
        uploadImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true //ep.17 5mins
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
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
        
        //inputTextField //sendButton, input textField, and separator line is copy pasted from setupInputComponents at ep.15 21mins
        containerView.addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 5).isActive = true //ep.17 6mins updated to constraint it to the uploadImage
        self.inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //separatorLineView
        let separatorLineView = UIView() //ep.8
        separatorLineView.backgroundColor = .gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        return containerView //ep.15 18mins
    }()
    
    var user: MyCourtUser? { //ep.9 added so we can give it a value from the newMessagesController
        didSet {
            navigationItem.title = user?.name //ep.9 7mins
            
            observeMessages() //ep.12 12mins
        }
    }
    
    let inputTextField: UITextField = { //ep.8
        let tf = UITextField() //ep.8
        tf.keyboardType = UIKeyboardType.default
        tf.clearButtonMode = UITextField.ViewMode.unlessEditing
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.delegate = self //gotta declare it at viewDidLoad
        return tf
    }()
    
    
//VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) //ep.13 gives it a padding
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0) //ep.24mins give scrollIndicatorInsets a padding to so it wont look weird, they go together with collectionView?.contentInset //removed in ep 15 22mins
        collectionView?.keyboardDismissMode = .interactive //ep.15 13mins
        
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true //ep.12 27mins will make our collection view have a scrollable feel
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId) //ep.12 register the cell
        
        inputTextField.delegate = self //ep.8
        
        handleKeyboardObservers() //ep.15 3mins
    }
    
    
    override var inputAccessoryView: UIView? { //ep.15 15mins since this is a property  on UIViewController, u override this by specifying a get
        get { //ep.15 15mins inside this getter you have to return a UIView type
            
            return inputContainerView //ep.15 19mins
        }
    }
    
    override var canBecomeFirstResponder: Bool { return true } //ep.15 20mins
    
    
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
        if let text = message.text { //ep.17 22mins added to avoid crash when sending image instead of just a a text
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32 //ep.13 16mins with the estimateFrameForText(text: String) method, we can even use it and equal it to a cell's bubbleWidthAnchor.constant *** MIND BLOWN!!! ***
        } else if message.imageUrl != nil { //ep.18 9mins call code block if its an iamge message
            cell.bubbleWidthAnchor?.constant = 200 //ep.18 10mins
            
        }
        
        return cell //ep.12
    }
    
//collectionView size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80 //ep.13 7mins added to adot to textView's height
        let message = messages[indexPath.item] //ep.13 10mins get the text item of messages //ep.18
        
        if let text = message.text { //ep.13 9mins before we can call estimeFrameForText(text:), we need to unwrap first //ep.18 11mins
            height = estimateFrameForText(text: text).height + 20 //ep.13 10mins
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue { //ep.18 11mins unwrap the imageWidth and imageHeight if image is not nil
            
            //h1 / w1 = h2 / w2
            //solve for h1
            //h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200) //ep.18 14mins 200 is constant width of bubbleView
            
            
        } //ep.18 11mins
        
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect { //ep.13 8mins
        let size = CGSize(width: 200, height: 1000) //ep13 8mins
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) //ep.13 9mins this is how you would use this NSStringDrawingOptions
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil) //ep13 7mins boundingRect for NSString which gives us the estimated frame of the entire textblock
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
        
        
        if let messageImageUrl = message.imageUrl { //ep.17 26mins
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl) //ep.17 26mins
            cell.messageImageView.isHidden = false //ep.17 27mins
            cell.bubbleView.backgroundColor = .clear //ep.17 28mins clear the bubbleView in order to view the messageImageView
        } else { //ep.17 26mins else hide the messageImageView
            cell.messageImageView.isHidden = true //ep.17 27mins
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
        
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.userUid else { return } //ep.12 //ep.16 8mins added toId with only a comma yo
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId) //ep.12 //ep.16 8mins .child(user?.userUid)! is added in order to save chat observes from Firebase and load the current user's messages only with the selected userUid (toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in //ep.12 //make sure you observe, not observeSingleEvent
//            print(snapshot) //ep.12 this shows us all the reference for the current user's messages. But now we have to fetch each messages from the reference from snapshot
            
            let messageId = snapshot.key //ep.12
            let messagesRef = Database.database().reference().child("messages").child(messageId) //ep.12
            messagesRef.observeSingleEvent(of: .value, with: { (snapshoot) in //ep.12 observeSingleEvent of .value
//                print(snapshoot) //ep.12
                
                guard let dictionary = snapshoot.value as? [String: AnyObject] else { return } //ep.12
                let message = ChatMessage(dictionary: dictionary) //ep.12
//                print("Message retrieved is...... \(message.text)") //ep.12 will print all of the message.text
                
                //if message.chatPartnerId() == self.user?.userUid { //ep.12 27mins check if chatPartnerId is equal to our toId (user we are sending the message to) then run code block, if not dont append our messages //ep.16 17mins where it got removed because previously we werent monitoring the messages based on this [ reference().child("user-messages").child(uid).child(toId) ] deep level node structure.But now that we monitored it this way by added the .child(toId), we're kind of guaranteed that the message will always belong to the person that we clicked into
                    self.messages.append(message) //ep.12 18mins add message to ChatMessage //dont forget to reload data
                    DispatchQueue.main.async { //ep.12
                        self.collectionView?.reloadData() //ep.12 19mins
//                        self.collectionView?.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: true) //this puts the view of collectionView all the way to the bottom of the screen with the latest message
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0) //ep.18 23mins
                        self.collectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true) //ep.18 24mins scroll to last index
                    //}
                }
                
            }, withCancel: nil) //ep.12
        }, withCancel: nil) //ep.12
        
    }
    
    
//    func setupInputComponents() { //ep.8
//        let containerView = UIView() //ep.8
//        containerView.backgroundColor = .white
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(containerView) //ep.8
//
//        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor) //ep15 6mins referenced in order to adapt to the keyboard's height
//        containerViewBottomAnchor?.isActive = true //ep15 6mins
//
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//    //sendButton
//        let sendButton = UIButton(type: .system) //type: .system makes the button look more clickable //ep.8
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        containerView.addSubview(sendButton)
//
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//    //inputTextField
//        containerView.addSubview(inputTextField)
//
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
//        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//    //separatorLineView
//        let separatorLineView = UIView() //ep.8
//        separatorLineView.backgroundColor = .gray
//        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(separatorLineView)
//
//        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
//    }
    
    
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self)
    }
    
//show/hide keyboard and handling the views
    func handleKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification , object: nil) //ep.18 26mins
        
//        self.initialY = view.frame.origin.y //to show/hide keyboard
//        self.offset = -80 //to show/hide keyboard //go "up" when decreasing the Y value
//        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil) //replaced at ep.18 25mins
//        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleViewsOnKeyboardShowOrHide(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func handleKeyboardDidShow() { //ep.18 26mins
        let indexPath = IndexPath(item: messages.count - 1, section: 0) //ep.18 26mins
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true) //ep.18 26mins
    }
    
    @objc func handleViewsOnKeyboardShowOrHide(notification: Notification) {
        //        print("Keyboard will show: \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return } //ep15 online as well
        
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double //ep15 8mins
//        let keyboardCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! Int
        
        if (notification.name == UIResponder.keyboardWillShowNotification) || (notification.name == UIResponder.keyboardWillChangeFrameNotification) {
//            self.view.frame.origin.y = -keyboardRect.height
            containerViewBottomAnchor?.constant = -keyboardRect.height //ep15 8mins
            UIView.animate(withDuration: keyboardDuration) { //ep15 10mins
                self.view.layoutIfNeeded() //ep15 10mins
            }
            
        } else if notification.name == UIResponder.keyboardWillHideNotification { //ep15 10mins
//            self.view.frame.origin.y = 0
            containerViewBottomAnchor?.constant = 0 //ep15 8mins
            UIView.animate(withDuration: keyboardDuration) { //ep15 10mins
                self.view.layoutIfNeeded() //ep15 10mins
            }
        }
        
        
    }
    
    
    //ep. 17 pictures Tapped method
    @objc func handleUploadTap() { //ep.17 7mins handles tap gestures the uploading images
        print("We tapped upload")
        let imagePickerController = UIImagePickerController() //ep.17 8mins
        imagePickerController.allowsEditing = true //ep.17 10mins
        imagePickerController.delegate = self //ep.17 9mins

        self.present(imagePickerController, animated: true, completion: nil) //ep.17 8mins
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //ep.17 10mins if successfully picked an image
        
        var selectedImageFromPicker: UIImage? //ep17 11mins
        //info was updated in Swift 4
        if let editedImage = info[.editedImage] as? UIImage { //ep17 11mins
            selectedImageFromPicker = editedImage //ep17 11mins
            
        } else if let originalImage = info[.originalImage] as? UIImage { //ep17 11mins
            selectedImageFromPicker = originalImage //ep17 11mins
        } //ep17 11mins
        
        if let selectedImage = selectedImageFromPicker { //ep17 11mins //if image is successfully unwrapped...
            uploadToFirebaseStorageUsingImage(image: selectedImage) //ep17 11mins
        }
        
        dismiss(animated: true, completion: nil) //ep17 11mins //after image is picked, dismiss vc
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //ep.17 10mins if canceled then dismiss imagePickerController
        dismiss(animated: true, completion: nil) //ep.17 10mins
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) { //ep.17 12mins
        print("image uploading to firebase...") //ep.17
        let imageName = NSUUID().uuidString //ep.17 13mins create a random image name
        let imageReference = Storage.storage().reference().child("message_images").child("0000\(imageName).jpg") //ep.17 14mins
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) { //ep.17 14mins //our uploadImage Data that we will be uploading to our firebase
            //if no error then putData //ep.17 15mins
            //let imageReference = ref.child(imageName) //ep.17 create our imageReference where we can putData
            imageReference.putData(uploadData, metadata: nil) { (metadata, error) in //ep.17 15mins
                if let error = error { //ep.17 15mins
                    print("Error uploading image\n\(error.localizedDescription)") //ep.17 15mins
                    Service.presentAlert(on: self, title: "Error on uploading image", message: error.localizedDescription) //ep.17 16mins
                }
                //if no error on puttingData...
                imageReference.downloadURL(completion: { (imageUrl, error) in
                    if let error = error { //ep.17 17mins updated version of downloadingUrl and putting the value to imageUrl, which we will later unwrap
                        Service.presentAlert(on: self, title: "Error on downloading image", message: error.localizedDescription)
                    }
                    //if no error on downloadUrl
                    if let messageImageUrl = imageUrl?.absoluteString { //ep.17 17mins //now with messageImageUrl we want to upload this image as a message object inside of firebase database under this "messages". We will put the messageImageUrl inside the "messages" text: node
                        
                        self.sendMessageWithImageUrl(imageUrl: messageImageUrl, image: image) //ep.17 18mins
                        
                    }
                })
            }
        }
    }
    
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) { //ep.17 18mins mostly copy-pasted from handleSend method
        let properties: [String : AnyObject] = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : AnyObject] //ep.17 18mins //ep.18 3mins image's width and height was added, dont forget to add then in our class ChatMessage //ep.18 19mins values are now properties that we will append to our values once we call sendMessageWithProperties(properties:) method
        
        sendMessageWithProperties(properties: properties) //ep.18 19mins pass the properties we want to append later to our method
    }
    
    
//sending message
    @objc func handleSend() { //ep.8 20mins
        
        let properties: [String: AnyObject] = ["text": inputTextField.text!] as [String : AnyObject] //ep.9 //ep.18 changed from values to properties that we will pass to our sendMessageWithProperties()
        sendMessageWithProperties(properties: properties)
        
//        let ref = Database.database().reference().child("messages")
//        let childRef = ref.childByAutoId() //create a child reference
//
//        let userUid = user!.userUid  //ep.9 //the user we will be sending to
//        let fromId = Auth.auth().currentUser!.uid //ep.9
//        let timeStamp:Int = Int(Date().timeIntervalSince1970) //ep.9
//        let values = ["text": inputTextField.text!, "userUid": userUid!, "fromId": fromId, "timeStamp": timeStamp] as [String : AnyObject] //ep.9
////        let values = ["text": inputTextField.text!, "users": user!.name!] as [String : Any] //ep.9 //"users": user!.name! is not a good idea because changing your name will require us to manually change the name in our database, which is ineffective
//
//        childRef.updateChildValues(values) //ep.9 //ep.11 added a completion block
//        childRef.updateChildValues(values) { (error, ref) in //ep.11 updateChildValues with completion handler to not broadcast everyone's messages
//            if let error = error {
//                Service.presentAlert(on: self, title: "Error", message: "\(error.localizedDescription)")
//                return
//            }
//            //if no error ep.11
//
//            self.inputTextField.text = nil //ep.13 19mins clear the textfield after handling send
//
//            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(userUid!) //ep.11 //ep.16 6mins .child(userUid) is added in order to save chat observes from Firebase //FIRST HALF OF EPISODE 16's goal is to create a subnode for each users in "user-messages". The subnode will be the userUid or the toId so that we will only OBSERVE messages we currently selected (which is the userUid we are currently on). We dont see other's messages anymore, but Firebase is still observing other people's messages, which can cost a lot of money
//
//            let messageId = childRef.key //ep.11 //ref's childByAutoId, gives us the node reference.key for when a new node is created
//            userMessagesRef.updateChildValues([messageId: 1]) //ep.11 8mins this is what you call the "fanning out" of two trees/nodes and messages gets the actual message information, then this user-messages just references what's inside the message node (fromId, text, timeStamp, toId)
//
//            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(userUid!).child(fromId) //ep.11 //ep.16 6mins .child(userUid) is added in order to save chat observes from Firebase
//            recipientUserMessagesRef.updateChildValues([messageId: 1])
//        }
//        self.inputTextField.resignFirstResponder() //put keyboard away
//        print("Sent text is... \(String(describing: inputTextField.text))")
    } //end of handleSend
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) { //ep.17 18mins mostly copy-pasted from handleSend method //ep.18 18mins since handleSend and sendMessageWithImageUrl are very similar, we will refactor it in one method with slight modifications
        
        let ref = Database.database().reference().child("messages") //ep.17 18mins
        let childRef = ref.childByAutoId() //ep.17 18mins
        
        let userUid = user!.userUid //ep.17 18mins //the user we will be sending to
        let fromId = Auth.auth().currentUser!.uid //ep.17 18mins
        let timeStamp:Int = Int(Date().timeIntervalSince1970) //ep.17 18mins
        
        
        var values: [String : AnyObject] = ["userUid": userUid!, "fromId": fromId, "timeStamp": timeStamp] as [String : AnyObject] //ep.17 18mins imageUrl is added //ep.18 3mins image's width and height was added, dont forget to add then in our class ChatMessage //ep.18 18mins imageUrl and image's width and height are removed but will be appended later with sendMessageWithImageUrl() method
        
        //key $0, value $1
        properties.forEach {values[$0] = $1} //ep.18 21mins forEach calls the given closure on each element in the sequence in the same order as a for-in loop with no break or continue, and, using the return statement in the body closure will exit only from the current call to body, not from any outer scope, and won’t skip subsequent calls //what this is pretty much doing is forEach key: value pairs from properties, append each one of them to our values dictionary
        
        
        childRef.updateChildValues(values) { (error, ref) in //ep.17 18mins updateChildValues with completion handler to not broadcast everyone's messages
            if let error = error { //ep.17 18mins
                Service.presentAlert(on: self, title: "Error", message: "\(error.localizedDescription)") //ep.17 18mins
                return
            } //ep.17 18mins
            
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(userUid!) //ep.17 18mins
            
            let messageId = childRef.key //ep.17 18mins
            userMessagesRef.updateChildValues([messageId: 1]) //ep.17 18mins
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(userUid!).child(fromId) //ep.17 18mins
            recipientUserMessagesRef.updateChildValues([messageId: 1]) //ep.17 18mins
        }
        
        //self.inputTextField.resignFirstResponder() //put keyboard away
        
        print("image uploaded to firebase successfully")
    }
    
}
