//
//  ChatMessageCell.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell { //ep.12 21mins
    
    var bubbleWidthAnchor: NSLayoutConstraint? //ep.13 15mins
    var bubbleViewRightAnchor: NSLayoutConstraint? //ep.14 12mins //now that we have reference to both bubbleView's right and left anchor, we can now set which one is active or not 
    var bubbleViewLeftAnchor: NSLayoutConstraint? //ep.14 13mins

    static let blueColor = UIColor(r: 0, g: 137, b: 249) //ep.14
    
    var chatLogController: ChatLogController? //ep.19 7mins reference to ChatLogController that we will equal to self in cellForItemAt indexPath
    
    
    let bubbleView: UIView = { //ep.13 4mins
        let view = UIView()
        view.backgroundColor = blueColor //ep14
        view.translatesAutoresizingMaskIntoConstraints = false //ep.134mins
        view.layer.cornerRadius = 16 //ep.13 18mins
        view.layer.masksToBounds = true //ep.13 18mins
        return view
    }()
    
    let textView: UITextView = { //ep.12 21mins UICollectionViewCell doesnt have a default text, unlike UITableViewCell
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear //ep.13 5mins so we can see the bubbleview
        tv.textColor = .white //ep.13
        tv.isEditable = false //ep.18 24mins added so we cant edit the textView
        return tv
    }()
    
    
    let profileImageView:UIImageView = { //ep.14 9mins
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple")
        imageView.translatesAutoresizingMaskIntoConstraints = false //ep.14 9mins
        imageView.contentMode = .scaleAspectFill //ep.14 9mins
        imageView.layer.cornerRadius = 16 //ep.14 11mins to make it rounded
        imageView.layer.masksToBounds = true //ep.14 11mins
        return imageView
    }()
    
    
    lazy var messageImageView: UIImageView = { //ep.17 23mins //ep.19 3mins changed to lazy var in order to access self and its method
        let imageView = UIImageView() //ep.17 23mins
        imageView.image = UIImage(named: "apple") //ep.17 23mins
        imageView.translatesAutoresizingMaskIntoConstraints = false //ep.17 23mins
        imageView.contentMode = .scaleAspectFill //ep.17 23mins
//        imageView.layer.cornerRadius = 16
//        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true //ep.19 3mins
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))) //ep.19 3mins
        return imageView
    }()
    
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) { //ep.19 4mins
        if let imageView = tapGesture.view as? UIImageView { //ep.19 8mins unwrap the imageView before we call the performZoom method, so it wont crash if the image is not a UIImageView
            
            //PRO TIP: dont perform a lot of custom logic inside of a view class //ep.19 6mins. Delegate the zooming animations to the controller class.
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView) //ep.19 7mins this is how you put a tap gesture to a view and have the function in the view controller
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8) //ep.14 12mins equalled the optional constraint ot this to have a reference to it
        bubbleViewRightAnchor?.isActive = true //ep.14 12mins
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8) //ep.14 14mins
//        bubbleViewLeftAnchor?.isActive = false //ep.14 14mins since by default it is false, comment it out
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200) //ep.13 15mins
        bubbleWidthAnchor?.isActive = true //ep.13 15mins
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        addSubview(textView)
        
//        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true //ep13 12mins //constraint them inside the bubble
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true //ep.13 12mins
//        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        addSubview(profileImageView) //ep.14 9mins
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true  //ep.14 10mins
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true //ep.14 10mins
        
        
        bubbleView.addSubview(messageImageView) //ep.17 23mins
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true //ep.17 23mins
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true //ep.17 23mins
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
