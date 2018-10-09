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
import MobileCoreServices //ep.20 4mins for videos
import AVFoundation //ep.20 4mins


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //ep.8 dont forget to call ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()) //ep.12 UICollectionViewDelegateFlowLayout is added //ep.17 8mins imagePicker an uiNavPicker are added
    
    let cellId:String = "cellId"
    var messages = [ChatMessage]()
    var containerViewBottomAnchor: NSLayoutConstraint? //ep.15 6mins
    
    lazy var inputContainerView: ChatInputContainerView = { //ep.15 18:40mins //you cant access self unless it's a lazy var, not let/var //ep.23 8mins changed the UIView class to ChatInputContainerView class
        
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)) //ep.23 4mins
        chatInputContainerView.chatLogController = self //ep.23 12mins this is needed so we have proper reference of chatLogController
        return chatInputContainerView //ep.23 5mins
    }() //end of inputContainerView
    
    
    var user: MyCourtUser? { //ep.9 added so we can give it a value from the newMessagesController
        didSet {
            navigationItem.title = user?.name //ep.9 7mins
            observeMessages() //ep.12 12mins
        }
    }
    
    
//VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) //ep.13 gives it a padding
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0) //ep.24mins give scrollIndicatorInsets a padding to so it wont look weird, they go together with collectionView?.contentInset //removed in ep 15 22mins
        collectionView?.keyboardDismissMode = .interactive //ep.15 13mins
        
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true //ep.12 27mins will make our collection view have a scrollable feel
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId) //ep.12 register the cell
        
        inputContainerView.inputTextField.delegate = self //ep.8
        
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
        
        cell.chatLogController = self //ep.19 6mins have to create a variable in our cell class
        
        let message = messages[indexPath.item] //ep.12 26mins
        cell.textView.text = message.text //ep12 26mins
        
        cell.message = message //ep.21 14mins for our video reference. Dont forget to add the optional property from ChatMessageCell or it wont work
        
        setupCell(cell: cell, message: message) //ep.14 6mins //setup the bubbleView's background color to blue or gray
        
    //ep.13 14mins before returning, make sure bubbleView's width is modified properly
        //cell.bubbleWidthAnchor?.constant = 50 //ep.13 16mins grab the cell's bubbleWidthAnchor optional var
        if let text = message.text { //ep.17 22mins added to avoid crash when sending image instead of just a a text
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32 //ep.13 16mins with the estimateFrameForText(text: String) method, we can even use it and equal it to a cell's bubbleWidthAnchor.constant *** MIND BLOWN!!! ***
            cell.textView.isHidden = false //ep.19 5mins
        } else if message.imageUrl != nil { //ep.18 9mins call code block if its an image message
            cell.bubbleWidthAnchor?.constant = 200 //ep.18 10mins
            cell.bubbleView.backgroundColor = .clear
            cell.textView.isHidden = true //ep.19 5mins hide textView so we can activate our image's tap gesture recognizer
        }
        
        cell.playButton.isHidden = message.videoUrl == nil //ep.21 11mins hide cell's playButton if message's videoUrl is nil //better than 5 line if-else
        
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
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //ep.8 //ep.23 18mins refactored and was moved to ChatInputContainerView class
//        handleSend()
////        textField.resignFirstResponder()
//
////
////        switch textField {
////        case inputTextField:
////            textField.resignFirstResponder()
////        default:
////            textField.resignFirstResponder()
////        }
//
//        return true
//    }
    

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
//        imagePickerController.allowsEditing = true //ep.17 10mins
        imagePickerController.delegate = self //ep.17 9mins
        imagePickerController.mediaTypes = [kUTTypeImage, kUTTypeMovie] as [String] //ep.20 4mins so we can also have video in our imagePickerController
        
        self.present(imagePickerController, animated: true, completion: nil) //ep.17 8mins
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //ep.17 10mins if successfully picked an image
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL { //ep.20 6mins grab and equal videoUrl to info dictionary with the infoKey of mediaURL, which contains our videoUrl from our device //with this url, we can upload this to firebase //dont forget to cast it as NSURL
//            print(videoUrl)file:///private/var/mobile/Containers/Data/Application/A45977E5-0DF2-425F-86EA-A2D42DCEB4E1/tmp/2B0B9D7B-9DA9-438E-8334-D1B3BD7209AC.MOV
            
            handleVideoSelectedForUrl(videoUrl) //ep.20 12mins
            
        } else { //ep.20 11mins runs when user selected an image instead of a video
            handleImageSelectedForInfo(info: info) //ep.20 11 mins then run this method
        }
        
        dismiss(animated: true, completion: nil) //ep17 11mins //after image is picked, dismiss vc
    }
    
    
    private func handleVideoSelectedForUrl(_ url: URL) {
        
        let filename = NSUUID().uuidString //ep.20 7mins create a random video name
        let fileReference = Storage.storage().reference().child("message_movies").child("0000\(filename).mov") //ep.17 14mins our file storage reference
        
        let uploadTask = fileReference.putFile(from: url, metadata: nil) { (metadata, error) in //ep.20 8mins putFile in our file storage reference
            if let error = error { //ep.20 8mins
                Service.presentAlert(on: self, title: "Error in Putting Video File", message: error.localizedDescription) //ep.20 8mins
            }
            
            //if no error put file to Firebase
            fileReference.downloadURL(completion: { (downloadedUrl, error) in //ep.20 9mins //if no erro rthen we can downloadUrl
                if let error = error { //ep.20 9mins //error check
                    Service.presentAlert(on: self, title: "Error in Downloading Video File", message: error.localizedDescription)
                }
            
            //if no error downloading movie file url
                //if let messageVideoUrl = videoUrl?.absoluteString { //unwrap the videoUrl as an absoluteString
                guard let videoUrl = downloadedUrl?.absoluteString else { return } //unwrap
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url) { //ep.20 26mins unwrap sice thumbnailImageForFileUrl method can return a nil
                    
                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl) in //ep.20 31mins with the completion block, we can now upload our thumbnailImage with out imageUrl
                        
                        //print(videoUrl) //ep.20 9mins
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": videoUrl] as [String: AnyObject] //ep.20 18mins dictionary of videoUrl properties we will include in our method //ep.20 27mins now we have the videoUrl, imageWidth and imageHeight from our thumbnailImage, but there is no image because we are missing our imageUrl
                        
                        self.sendMessageWithProperties(properties: properties) //ep.20 19mins like with our messages, this will take care of the message referencing and properties for which the file is from and sent to, timeStamp. Then the method will updateChildValues, clear the textField, and control which viewers can view the right videos //But this will only create the bubble for it without an image. We will get this image by grabbing the first frame of the movie file using an asset generator 20mins
                    }) //ep.20 31mins
                
                }
            })
        }

        uploadTask.observe(StorageTaskStatus.progress) { (snapshot) in //ep.20 13mins we cant tell if we're really uploading or the progress of it, so we create a reference for the task which is uploadTask
//            print(snapshot.progress?.completedUnitCount) //ep.20 14mins
            if let completedUnitCount = snapshot.progress?.completedUnitCount { //ep.20 15mins
                self.navigationItem.title = String(completedUnitCount) //ep.20 15mins
            }
            
        }
        
        uploadTask.observe(.success) { (snapshot) in //ep.20 16mins observe method which is called once uploadTask is finished
            self.navigationItem.title = self.user?.name //ep.20 16mins return the title back to the user's name
        }
    }
    
    
    private func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage? { //ep.20 21mins generate a thumbnail image //ep.20 25mins returned UIImage is optional
        let asset = AVAsset(url: fileUrl) //ep.20 22mins create an AVAsset with the url // AVAsset = The abstract class used to model timed audiovisual media such as videos and sounds.
        let imageGenerator = AVAssetImageGenerator(asset: asset) //ep.20 22mins AVAssetImageGenerator = An object that provides thumbnail or preview images of assets independently of playback
        
        do { //ep.20 24mins do-try-catch is needed for imageGenerator.copyCGImage
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil) //ep.20 23mins basically this gives us the first frame of the video file for this url. //copyCGImage = Returns a CGImage for the asset at or near a specified time. //CMTimeMake = Makes a valid CMTime with value and timescale. Epoch is implied to be 0. "value" parameters Initializes the value field of the resulting CMTime. "timescale" = Initializes the timescale field of the resulting CMTime.
            return UIImage(cgImage: thumbnailCGImage) //ep.20 26mins if successful, then return our thumbnailCGImage
            
        } catch let error { //ep.20 24mins
            Service.presentAlert(on: self, title: "Error Generating thumbnail", message: error as! String) //ep.20 24mins
        }
        
        return nil //ep.20 23mins returns a nil if we cant get a frame from movie
    }
    
    
    private func handleImageSelectedForInfo(info: [UIImagePickerController.InfoKey : Any]) { //ep.20 11mins
        var selectedImageFromPicker: UIImage? //ep17 11mins
        //info was updated in Swift 4
        if let editedImage = info[.editedImage] as? UIImage { //ep17 11mins
            selectedImageFromPicker = editedImage //ep17 11mins
            
        } else if let originalImage = info[.originalImage] as? UIImage { //ep17 11mins
            selectedImageFromPicker = originalImage //ep17 11mins
        } //ep17 11mins
        
        if let selectedImage = selectedImageFromPicker { //ep17 11mins //if image is successfully unwrapped...
            uploadToFirebaseStorageUsingImage(image: selectedImage) { (imageUrl) in //ep.17 11mins //ep.20 30mins updated to this as we added a completion block to the method
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage) //ep.17 18mins //ep.20 31mins moved here from uploadToFirebaseStorageUsingImage
                
            }
        }
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //ep.17 10mins if canceled then dismiss imagePickerController
        dismiss(animated: true, completion: nil) //ep.17 10mins
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String) ->() ) { //ep.17 12mins //ep.20 30mins completion block gets executed on completion
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
                        
                        completion(messageImageUrl)
                        
//                        self.sendMessageWithImageUrl(imageUrl: messageImageUrl, image: image) //ep.17 18mins //ep.20 31mins moved to handleImageSelectedForInfo method in the completion block
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
        
        let properties: [String: AnyObject] = ["text": inputContainerView.inputTextField.text!] as [String : AnyObject] //ep.9 //ep.18 changed from values to properties that we will pass to our sendMessageWithProperties()
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
            
            self.inputContainerView.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(userUid!) //ep.17 18mins
            
            let messageId = childRef.key //ep.17 18mins
            userMessagesRef.updateChildValues([messageId: 1]) //ep.17 18mins
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(userUid!).child(fromId) //ep.17 18mins
            recipientUserMessagesRef.updateChildValues([messageId: 1]) //ep.17 18mins
        }
        //self.inputTextField.resignFirstResponder() //put keyboard away
        print("image uploaded to firebase successfully")
    }
    
    
    
    
    var startingFrame: CGRect? //ep.19 23mins //our reference to where the image we tapped came from
    var blackBackgroundView: UIView? //ep.19 26mins
    var startingImageView: UIImageView? //ep.19 31mins
    
//THIS METHOD IS CALLED IN THE ChatMessageCell VIEW AS A TAP GESTURE
    func performZoomInForStartingImageView(startingImageView: UIImageView) { //ep.19 7mins, a customed imageView zooming method.
        //print("Zooming to a pic") //ep.19 9mins
        self.startingImageView = startingImageView //ep.19 31mins equal startingImageView to the parameter
        self.startingImageView?.isHidden = true //ep.19 32mins hide the startingImageView
        
        self.startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil) //ep.19 10mins this frame is what we will need to put a frame on top of our imageView //SUPERVIEW = The receiver’s superview, or nil if it has none //
/*
        ==============================  .CONVERT     ==========================
        SUMMARY
            Converts a rectangle from the receiver’s coordinate system to that of another view
        
        PARAMETERS
        
         rect
            A rectangle specified in the local coordinate system (bounds) of the receiver.
        
         view
            The view that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates. Otherwise, both view and the receiver must belong to the same UIWindow object.
        
         RETURNS
            The converted rectangle.
 */
        //print("\(String(describing: startingFrame))") //ep.19 11mins //SUPERVIEW The receiver’s superview, or nil if it has none. //Prints... Optional((167.0, 408.5, 200.0, 200.5)) //(x: , y: , width: , height: )
        
        let zoomingImageView = UIImageView(frame: startingFrame!) //ep.19 12mins create an imageView with our startingFrame's
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image //ep.19 16mins put the startingImageView:'s iamge to our zoomingImageView
        
        zoomingImageView.isUserInteractionEnabled = true //ep.19 22mins
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(tapGesture:)))) //ep.19 21mins use to zoom out
        
        
        if let keyWindow = UIApplication.shared.keyWindow { //ep.19 12mins add the view to our application //KEYWINDOW = The app's key window. This property holds the UIWindow object in the windows array that is most recently sent the makeKeyAndVisible() message. //this way of adding an image remains through different Controllers, so remember to remove it
            
            self.blackBackgroundView = UIView(frame: keyWindow.frame) //ep.19 19mins
            blackBackgroundView?.backgroundColor = .black //ep.19 19mins
            blackBackgroundView?.alpha = 0 //ep.19 19mins make it invisible at start and make it visible in the ANIMATION
            
//            blackBackgroundView?.isUserInteractionEnabled = true
//            blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(tapGesture:))))
            keyWindow.addSubview(blackBackgroundView!) //ep.19 19mins add it before zoomingImageView
            
            keyWindow.addSubview(zoomingImageView) //ep.19 13mins add the zoomingImageView to our keyWindow with an animation...
        ////now make a zooming animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { //ep.19 14mins the animation with 0.5 duration, no delay, .curveEaseOut, with its own animation, and a completion block //ep.19 29mins animation is updated to have some acceleration.
                self.blackBackgroundView?.alpha = 1 //ep.19 20mins make blackBackgroundView visible
                self.inputContainerView.alpha = 0 //ep.19 20mins hide the inputContainerView with the textField and Button
                
            //equation we need for getting the right height
                // h2 / w2 = h1 / w1
                // h2 = h1 / w1 * w2
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width //ep.19 17mins //keyWindow.frame.height / keyWindow.frame.width = startingFrame!.height / startingFrame!.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height) //ep.19 14mins create its frame //ep.19 17mins height was changed from keyWindow.frame.height
                zoomingImageView.center = keyWindow.center //ep.19 15mins center it
                
            }, completion: nil) //ep.19 14mins
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) { //ep.19 21mins //to have a proper zoom out animation, we need our initial startingFrame so we know where the final destination is.
        print("Zooming out...") //ep.19 22mins
        guard tapGesture.view != nil else { return } //check first
        
        
        if let zoomOutImageView = tapGesture.view { //ep.19 24mins The view the gesture recognizer is attached to.
            //need to animate back to the controller
            zoomOutImageView.layer.cornerRadius = 16 //ep.19 33mins to remove that rectangle imageView snapping to the startingImageView's cornerRadius
            zoomOutImageView.clipsToBounds = true //ep.19 33mins needed for cornerRadius
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { //ep.19 28mins this changes the zoom out animation with a little accceleration on zooming out, instead of a linear speed of zooming out
            //UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { //ep.19 24mins //ep.19 28mins updated with an animate method with usingSprintWithDamping
                
                zoomOutImageView.frame = self.startingFrame! //ep.19 25mins reset our imageView back to where it's from
                self.blackBackgroundView?.alpha = 0 //ep.19 26mins
                self.inputContainerView.alpha = 1 //ep.19 30mins
                
            }) { (completed: Bool) in //ep.19 24mins the completion block is where we'll erase the views
                zoomOutImageView.removeFromSuperview() //ep.19 27mins remove our imageView completely so it wont persist through other controllers
                self.startingImageView?.isHidden = false
            }
        }
    }
    
}
