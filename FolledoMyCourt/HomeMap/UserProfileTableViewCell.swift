//
//  UserProfileTableViewCell.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 9/4/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    var message: String?
    var mainImage: UIImage?
    
    var messageLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
//        label.isScrollEnabled = false //this will make the cell not scrollable and the text will determine the size of the textView
//        label.font = .boldSystemFont(ofSize: 16)
//        label.isEditable = false
//        label.isSelectable = true
        return label
    }()
    
    var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
//initializer
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainImageView)
        self.addSubview(messageLabel)
        
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        messageLabel.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: 10).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        messageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
//        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//now we add information into them, but u cant do it in the initializer because those information are not initially provided, it is added after initialization
    override func layoutSubviews() {
        super.layoutSubviews()
        if let message = message { //unwrap first
            messageLabel.text = message
        }
        if let image = mainImage {
            mainImageView.image = image
        }
    } //now that we have this, it is time to put it in our table view. First register it with ur table view cell, so it has an identifier (reuseIdentifier) so we can reuse it over and over again
    
    
    
}
