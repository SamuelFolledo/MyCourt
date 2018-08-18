//
//  AppDelegate.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import UserNotifications //Firebase S5-L15 //5mins

import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate { //Firebase S5-L15 //5mins 'MessagingDelegate'

    var window: UIWindow?
    
//    let providers: [FUIAuthProvider] = [ FUIGoogleAuth() ]
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
    //for Facebook Login
        //[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions]; //Objective-C version
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions) //Swift 3&4 version
        
    //for Firebase
        FirebaseApp.configure() //1
        
//for Firebase Messaging/Notifications //***** https://firebase.google.com/docs/cloud-messaging/ios/first-message?authuser=0 *****
        if #available(iOS 10.0, *) { //Firebase S5-L15 //5mins ***TO REGISTER FOR REMOTE NOTIFICATIONS*** //this will make ur notifications more applicable to different versions of iOS
            //For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate //Firebase S5-L15 //5mins
            
            let authoOptions: UNAuthorizationOptions = [.alert, .badge, .sound] //Firebase S5-L15 //5mins
            UNUserNotificationCenter.current().requestAuthorization(options: authoOptions) { (_, _) in } //Firebase S5-L15 //5mins
        } else { //Firebase S5-L15 //5mins
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil) //Firebase S5-L15 //5mins
            application.registerUserNotificationSettings(settings) //Firebase S5-L15 //5mins
        }
    //registers for notification
        application.registerForRemoteNotifications() //Firebase S5-L15 //5mins
        
        Messaging.messaging().delegate = self //Firebase S5-L15 //8mins
        let token = Messaging.messaging().fcmToken //Firebase S5-L15 //8mins
        print("FMC token: \(token ?? "")") //Firebase S5-L15 //8mins
        
        let token2 = InstanceID.instanceID().token()
        print("My token is \(token) ... \(token2)")
        
        
//        InstanceID.instanceID().instanceID { (result, error) in //You can retrieve the token directly using instanceIDWithHandler:. This callback provides an InstanceIDResult, which contains the token.
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
//            }
//        }
        
        
        
    //for AdMob
        GADMobileAds.configure(withApplicationID: "ca-app-pub-7199410801226990~1516633985") //AdMob //2mins "MY APP's ID"
        let request = GADRequest()
        request.testDevices = []
        
        
    //now load the main View Controller
        //let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KobeVC") as UIViewController
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") //instatiate/call the Main.storyboard's initial VC
        window = UIWindow(frame: UIScreen.main.bounds) //
        window?.makeKeyAndVisible() //makes the window visible
        window?.rootViewController = viewController //makes MainTabVC the rootView
        
        return true
    }
    
    
    
//didReceiveRemoteNotification for handling pushes (notifications) //this is called when a user taps on a notification //Udemy_HandlingPushes_S18L227
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { //if someone is outside of the app and then taps on a notification, it will open up the app and then it will call this function didReceiveRemoteNotification, where you can take them to custome page or VC in the app
        print("User tapped on the notification!")
        
    }
//Udemy_HandlingPushes_S18L227 //this one is for when user is already in the app. Even though theyre using your app, something new has happened that theyre supposed to be knowing about, then we let notificationHandler to handle that
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { //then we can run any function we want if the user is already in the app, like add an alert, or send them to another VC
        print("WE ARE IN THE APP")
        
        completionHandler([.alert,.badge,.sound]) //in completionHandler, pass in an array of things we would like to happen, which in here we alert, badge, and sound which are some of the things that a push notiifcation would have if it was outside of the app, but here we're doing it while inside the app
    } //NEEDS TO BE CHECKED CUZ CURRENTLY NOT GETTING RAN
    
//for push notifications CALLED/ MONITORING TOKEN REFRESH
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Messaging.messaging().subscribe(toTopic: "News") //Firebase18 //7mins the topic we will be writing to depending on the user's subscriptions
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
   
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) { //Firebase18 //3mins 'userInfo' holds the key value pairs that we can parse through
        if let messageID = userInfo["gcm.message_id"]{
            print("Message ID: \(messageID)")
        }
        
        print("PRINT FULL MESSAGE")
        print(userInfo)
    }
    
    
//for Facebook Login
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) //Swift 4 version
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options) //FBLogin //10mins
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}

