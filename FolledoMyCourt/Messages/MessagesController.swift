//
//  MessagesController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/2/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MessagesController: UITableViewController {
    
    let cellId = "cellId"
    var timer: Timer? //ep.14 25mins reference for the timer so we can have a better table reloading and helps fix some bugs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        
        let image = UIImage(named: "new_message")
        let newMessage:UIBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
//        let createMessage:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(showChatController)
        navigationItem.rightBarButtonItem = newMessage
        
        
        checkCurrentUser()
        
//        observeMessages() //ep.9 //ep.11 removed
        observeUserMessages() //ep.11
        
        
    }
    
    var messages = [ChatMessage]() //ep.9
    var messagesDictionary = [String: ChatMessage]() //ep.10
    
    
    func observeUserMessages() { //ep.11
        guard let userUid = Auth.auth().currentUser?.uid else { return } //ep.11
        
        let ref = Database.database().reference().child("user-messages").child(userUid)
        ref.observe(.childAdded, with: { (snapshot) in //ep.11 11mins once we got the reference, then we can observe. The "user-messages" will have a child of the current user which has a child of the reference of all their messages from "messages"
//            print(snapshot)
            let messageId = snapshot.key //ep.11
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshoot) in
//                print(snapshoot)
                
                //now we convert our snapshot into our ChatMessage NSObject
                if let dictionary = snapshoot.value as? [String: AnyObject] { //ep.9
                    //print(snapshoot)
                    let message = ChatMessage(dictionary: dictionary) //ep.9
                    //print("\(String(describing: message.text))") //ep.9
                    
    //                self.messages.append(message) //ep.9 APPEND //commented out to be equal to messagesDictionary
                    let chatPartnerId = message.chatPartnerId() //ep.10 if let toId = message.userUid //ep.13 22mins updated to this is if I reply, it wont create another cell in the MessagesController
                    self.messagesDictionary[chatPartnerId] = message //ep.10 23mins //we will only contain inside messagesDictionaryArr one message per toId or userId. Meaning if the same user sends us another message, it will update the toId key's value to that new message
                    
                    self.messages = Array (self.messagesDictionary.values) //ep.10 equal or put messagesDictionary's values to messages
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        
                        return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)! //ep.10 26mins //to sort in descending order
                    })
                    
                    self.timer?.invalidate() //ep.14 25mins invalidate() Stops the timer from ever firing again and requests its removal from its run loop. //ep.14 26mins because we are looping and observing so many messages, we just invalidate the timer everytime we get a new one. Finally in the end, call handleReloadTable on the last one
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false) //ep.14 23mins this will prevent reloading the table too much which can cause minor bugs
                    
                }
            }, withCancel: nil)
        }, withCancel: nil) //ep.11
    }
    
    
    @objc func handleReloadTable() { //ep.14 22mins this is a good work around to reduce flickers and minor bugs and the amount of time to reload the table
    //ep.10
        DispatchQueue.main.async {
            print("we reloaded the table") //ep.14 21mins we're loading the entire table everytime a message is being observe so this prints out a lot of times which can cause some error in our profileImage //22mins we fix that by reloading it once using a delay with NSTimer
            self.tableView.reloadData() //ep.9
        }
    }
    
//observe our messages
//    func observeMessages() { //ep.9
//        let ref = Database.database().reference().child("messages") //ep.9
//        ref.observe(.childAdded, with: { (snapshot) in //ep.9
//
//    //now we convert our snapshot into our ChatMessage NSObject
//            if let dictionary = snapshot.value as? [String: AnyObject] { //ep.9
//                //print(snapshot)
//                let message = ChatMessage(dictionary: dictionary) //ep.9
//                //print("\(String(describing: message.text))") //ep.9
//
////                self.messages.append(message) //ep.9 APPEND //commented out to be equal to messagesDictionary
//                if let toId = message.userUid { //ep.10
//                    self.messagesDictionary[toId] = message //ep.10 23mins //we will only contain inside messagesDictionaryArr one message per toId or userId. Meaning if the same user sends us another message, it will update the toId key's value to that new message
//
//                    self.messages = Array (self.messagesDictionary.values) //ep.10 equal messagesDictionary's values to messages
//                    self.messages.sort(by: { (message1, message2) -> Bool in
//
//                        return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)! //ep.10 26mins //to sort in descending order
//                    })
//
//                } //ep.10
//                DispatchQueue.main.async {
//                    self.tableView.reloadData() //ep.9
//                }
//            }
//
//        }, withCancel: nil) //ep.9
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId") //ep.9 //replaced at ep.10
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell//ep.9-10 need to be cast to as! UserCell
        
        let message = messages[indexPath.row] //ep.9
        cell.message = message //ep.10 set cell's message to message from messages
        
        if let cellTextLabel = cell.textLabel {
            cellTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cellTextLabel.text = message.userUid //ep.9
            //        cell.detailTextLabel?.text = message.text //ep.10 //job's moved to UserCell
        }
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //ep.12
        
        let message = messages[indexPath.row] as ChatMessage //ep.12
        let chatPartnerId = message.chatPartnerId() //ep.12
        let ref = Database.database().reference().child("users").child(chatPartnerId) //ep.12
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in //ep.12
//            print(snapshot)
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return } //ep.12
            let user = MyCourtUser(dictionary: dictionary) //ep.12
            user.userUid = chatPartnerId //ep.12 set the toId or userUid as the chatPArtnerId
            //            user.setValuesForKeys(dictionary) //ep.12 //these are not needed anymore because we equalled user to MyCourtUser(dictionary: dictionary)
            self.showChatControllerForUser(user: user) //ep.12
            
        }, withCancel: nil) //ep.12
        
        
        
        
        
        
//         print("\(message.text! + message.userUid! + message.fromId!)") //ep.12since we have a userUid (toId) and a fromId, we cant really guarantee which is who
        
    }
    
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self //ep.9 makes the newMessageController.messagesController = to MessagesController
        
        let navController = UINavigationController(rootViewController: newMessageController) //will give us a nav bar
        present(navController, animated: true, completion: nil)
    }

    
    
    func checkCurrentUser() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchCurrentUserAndSetupNavBarTitle()
        }
    }
    
//fetch Current User
    func fetchCurrentUserAndSetupNavBarTitle() {
        if let uid = Auth.auth().currentUser?.uid { //unwrap the currentUser's uid
            
            print("UID = \(uid)")
            Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in //listen for a single value, which is the current user
                print("observed")
                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    if let userName:String = dictionary["name"] as? String {
//                        print(userName)
//                        self.navigationItem.title = userName //set the title as the name from the snapshot //changed
                        
                    let user = MyCourtUser(dictionary: dictionary) //ep.7
                    self.setupNavBarWithCurrentUser(user: user) //ep.7
                    
                }
                
            }, withCancel: nil) //withCancel nil is safer and less error
        }
    }
    
//navBar that will display current user's image and name to our nav bar
    func setupNavBarWithCurrentUser(user: MyCourtUser) { //ep.7
        messages.removeAll() //ep.11 clear everything for when user logs in
        messagesDictionary.removeAll() //ep.11
        tableView.reloadData() //ep.11
        
        observeUserMessages() //ep.11 after clearing, reload by observingUserMessages
        
        
        let titleView = UIView() //ep.7 //the titleView which will contain our image and name
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = .red
        
        
    //after adding the titleView, profileImageView, and nameLabel, they dont fit correctly, and the containerView will be our solution
        let containerView = UIView() //ep.7
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView) //adds containerView to the titleView
        
        
    
    //profileImage
        let profileImageView = UIImageView()
        containerView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl { //ep.7
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    //nameLabel
        let nameLabel = UILabel() //ep.7
        containerView.addSubview(nameLabel)
        
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        
    //containerView constraints
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        print("Current user name and image is loaded")
        self.navigationItem.titleView = titleView //ep.7
    }
    
//showChatController
    @objc func showChatControllerForUser(user: MyCourtUser) { //ep.8 //ep.9 user parameter is added so we have a reference to which user we selected and want to send text to
        print("Going to chat log")
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()) //ep.8
        chatLogController.user = user //ep.9 must create a user reference to ChatLogController
        navigationController?.pushViewController(chatLogController, animated: true) //ep.8
    }
    
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do { try Auth.auth().signOut() }
        catch let logoutError {
            Service.presentAlert(on: self, title: "Logout Error", message: (logoutError as? String)!)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self //ep.7 bug fix
        self.present(loginController, animated: true, completion: nil)
    }
    
}
