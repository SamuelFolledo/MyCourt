//
//  RootViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 10/5/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    private var current: UIViewController
    
    init() {
        self.current = LaunchScreenController()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current) //addChildViewController //1 once we add the childViewController
        current.view.frame = view.bounds //2 we adjust its frame by calling current.view's frame to the view.bounds
        view.addSubview(current.view) //3 add the new subview
        current.didMove(toParent: self) //4 and call didMove(toParentViewController:). This will finish adding the child view controller and displaying it
        showLoginScreen()
    }
    
    
//--------------------   navigation methods   -------------------------------
    func showLoginScreen() {
        print("showing login screen")
        let new = UINavigationController(rootViewController: LoginController()) //1 create the LoginController
        
        addChild(new) //2 add it as a child view controller
        new.view.frame = view.bounds //3 align its frame
        view.addSubview(new.view) //4 add its view as a subview
        new.didMove(toParent: self) //5 call didMove
        
        current.willMove(toParent: nil) //6 prepare the current view controller for being removed by calling willMove()
        current.view.removeFromSuperview() //7 Finally, and remove the current view from the superview
        current.removeFromParent() //8 and remove the current view controller from the RootViewController
        
        current = new //9 update the current view controller
    }
    
    
    func switchToMainScreen() {
        print("switching to main tab bar controller")
//        let mainTabController = MainTabBarController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") //because our MainTabBarController is created with storyboard
        //let new = UINavigationController(rootViewController: vc)
        animateFadeTransition(to: vc)
    }
    
    
    func switchToLogout() {
        print("switching to login controller")
        let loginViewController = LoginController()
//        let logoutScreen = UINavigationController(rootViewController: loginViewController)
        animateDismissTransition(to: loginViewController)
        
    }
    
    
// ----------------------------   transitions   --------------------------------
    
    private func animateFadeTransition (to new: UIViewController, completion: (() -> Void)? = nil) { //to animate with fade transition, similar to showLoginScreen, but all the last steps are performed after the animation is finished
        current.willMove(toParent: nil)
        addChild(new) //addChild the new UIViewController parameter
        
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            print("Transitioning...")
        }) { (isCompleted) in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?() //1 To notify the caller of a successful transition, we call a completion handled at the end
        }
    }
    
    
    private func animateDismissTransition(to new: UIViewController, completion:(() -> Void)? = nil) {
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height) //start from the left side of the screen
        current.willMove(toParent: nil) //willMove = Called just before the view controller is added or removed from a container view controller.
        addChild(new)
//        current.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: { //transition = This method adds the second view controller's view to the view hierarchy and then performs the animations defined in your animations block. After the animation completes, it removes the first view controller's view from the view hierarchy.
            print("Dismiss Transition is happening")
            new.view.frame = self.view.bounds
        }) { (isCompleted) in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
