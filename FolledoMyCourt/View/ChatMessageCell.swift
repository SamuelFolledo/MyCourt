//
//  ChatMessageCell.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import AVFoundation //ep.21 13mins needed to play video

class ChatMessageCell: UICollectionViewCell { //ep.12 21mins
    
    var bubbleWidthAnchor: NSLayoutConstraint? //ep.13 15mins
    var bubbleViewRightAnchor: NSLayoutConstraint? //ep.14 12mins //now that we have reference to both bubbleView's right and left anchor, we can now set which one is active or not 
    var bubbleViewLeftAnchor: NSLayoutConstraint? //ep.14 13mins
    static let blueColor = UIColor(r: 0, g: 137, b: 249) //ep.14
    
    var message: ChatMessage? //ep.21 14mins needed for reference
    
    
    var chatLogController: ChatLogController? //ep.19 7mins reference to ChatLogController that we will equal to self in cellForItemAt indexPath
    
    
    lazy var playButton: UIButton = { //ep.21 3mins
        let button = UIButton(type: .system) //ep.21 3mins .system or it wont be that interactive
        //button.setTitle("Play Video", for: .normal) //ep.21 3mins
        button.translatesAutoresizingMaskIntoConstraints = false //ep.21 3mins
        let image = UIImage(named: "play-button") //ep.21 6mins
        button.tintColor = .white //ep.21 7mins not the tint default color, but white
        button.setImage(image, for: .normal) //ep.21 7mins
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside) //ep.21 12mins
        return button
    }()
    
    var activityIndicatorView: UIActivityIndicatorView = { //ep.21 24mins
        let aiy = UIActivityIndicatorView(style: .whiteLarge) //ep.21 24min
        aiy.translatesAutoresizingMaskIntoConstraints = false //ep.21 25mins
        aiy.hidesWhenStopped = true //ep.21 26mins hides when it stops
//        aiy.startAnimating() //ep.21 26mins starts it animating in the beginning
        return aiy
    }()
    
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
    
    
    var playerLayer: AVPlayerLayer? //ep.21 21mins
    var player: AVPlayer? //ep.21 22mins
    
    @objc func handlePlay() { //ep.21 12mins
        if let videoUrlString = message?.videoUrl, let videoUrl = URL(string: videoUrlString) { //ep.21 14mins get the videoUrl from message reference we have created. Also unwrap the url
            player = AVPlayer(url: videoUrl) //ep.21 13mins AVPlayer with the url
            playerLayer = AVPlayerLayer(player: player!) //ep.21 16mins //this will be our actual playerLayer, which will play our video but not display it yet
            playerLayer?.frame = bubbleView.bounds //ep.21 18mins the video will now render when we play it
            bubbleView.layer.addSublayer(playerLayer!) //ep.21 17mins add it to the bubbleView, but we still cant see the video playing
            
            player?.play() //ep.21 15mins play the video!!
            activityIndicatorView.startAnimating() //ep.21 27mins cause spinner to start
            playButton.isHidden = true //ep.21 28mins
            
//            if player?.actionAtItemEnd
            print("Attempting to play video") //ep.21 15mins
        }
    }
    
    
    override func prepareForReuse() { //ep.21 19mins this method resets the cells reused. Needed for our video to do clean up works
        super.prepareForReuse() //ep.21 20mins basically we want to remove the objects everytime we recycle a cell
        playerLayer?.removeFromSuperlayer() //ep.21 21mins this will stop the video from playing, but audio is still playing
        player?.pause() //ep.21 22mins pauses the video's sound
        activityIndicatorView.stopAnimating() //ep.21 29mins
    }
    
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) { //ep.19 4mins
        if message?.videoUrl != nil { //ep.21 30mins, dont zoom if it has videoUrl
            return //ep.21 30mins
        } //ep.21 30mins
        
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
        
        
        bubbleView.addSubview(playButton) //ep.21 3mins add it after messageImageView
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true //ep.21 3mins
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true //ep.21 3mins
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true //ep.21 4mins
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true //ep.21 4mins
        
        bubbleView.addSubview(activityIndicatorView) //ep.21 25mins add it after messageImageView
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true //ep.21 25mins
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true //ep.21 25mins
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true //ep.21 25mins
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true //ep.21 25mins
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
