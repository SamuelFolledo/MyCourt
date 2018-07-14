//
//  Service.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/14/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class Service {
    
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor = UIColor.white
    static let buttonBackgroundColorSignInAnonymously = UIColor(red: 88, green: 86, blue: 214, alpha: 1)
    static let buttonCornerRadius: CGFloat = 7
    
//showAlert
    static func showAlert(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil ) { //Signin Anonymously //30mins
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
//        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil) //dismiss action
//        alert.addAction(action)
        for action in actions { //to have as much actions as possible, then we loop through it
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion) //we add a completion, so we can do something when showAlert is presented
    }
    
}
