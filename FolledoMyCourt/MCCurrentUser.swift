//
//  MCCurrentUser.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 10/24/18. 2:00 AM
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//
//
//import Foundation
//import FirebaseAuth
//
//class MCCurrentUser {
//
//    let objectId: String
//    var pushId: String? //optional
//
//    let createdAt: Date
//    var updatedAt: Date
//
//    var coins: Int
//    var team: String
//    var firstName: String
//    var lastName: String
//    var fullName: String
//
//    var age: Int
//    var birthday: String
//    var gender: String
//    var height: String
//    var wingspan: String
//    var favoriteNBATeam: String
//
//
//    var avatar: String
//    var phoneNumber: String
//    var additionalPhoneNumber: String
//
//    var homeCourt: String
//    var awayCourt: String
//    var awayCourt2: String
//    var isKing: Bool
//    var isProPlayer: Bool //playerPro
//    var statsWinLose: String
//    var skill1: String
//    var skill2: String
//
//
//
//    init(_objectId: String, _pushId:String?, _createdAt: Date, _updatedAt: Date, _firstName: String, _lastName: String, _avatar: String = "", _phoneNumber: String = "") { //RE ep.11 6mins if you dont pass in any value, our initializer will assume it to be an empty string, phoneNumber is default empty string
//        objectId = _objectId //RE ep.11 10mins
//        pushId = _pushId //RE ep.11 10mins
//
//        createdAt = _createdAt //RE ep.11 10mins
//        updatedAt = _updatedAt //RE ep.11 10mins
//
//        coins = 10 //RE ep.11 10mins
//        firstName = _firstName //RE ep.11 10mins
//        lastName = _lastName //RE ep.11 10mins
//        fullName = _firstName + " " + _lastName //RE ep.11 10mins
//        avatar = _avatar //RE ep.11 10mins
//        isProPlayer = false //RE ep.11 10mins
//        team = "" //RE ep.11 10mins
//
//
//        phoneNumber = _phoneNumber //RE ep.11 10mins
//        additionalPhoneNumber = "" //RE ep.11 10mins
//
//    }
//
//    init(_dictionary: NSDictionary) { //RE ep.11 10mins in order to save something to our Firebase, we need to convert it to an NSDictionary which is a type JSON
//        
//        objectId = _dictionary[kOBJECTID] as! String //RE ep.13 0min crash if user has no objectId
//        pushId = _dictionary[kPUSHID] as? String //RE ep.13 1min this one can be nil
//        
//        
//        if let dcoin = _dictionary[kCOINS] { //RE ep.13 2mins
//            coins = dcoin as! Int //RE ep.13 2mins
//        } else { coins = 0 } //RE ep.13 2mins if no coins saved, we'll assume coins is 0
//        
//        if let comp = _dictionary[kCOMPANY] { //RE ep.13 2mins check company name
//            company = comp as! String //RE ep.13 2mins
//        } else { company = "" } //RE ep.13 2mins if no company name then set it to nothing
//        
//        if let fname = _dictionary[kFIRSTNAME] { //RE ep.13 2mins check name
//            firstName = fname as! String //RE ep.13 2mins
//        } else { firstName = "" } //RE ep.13 2mins if no name then set to nothing
//        
//        if let lname = _dictionary[kLASTNAME] { //RE ep.13 2mins check name
//            lastName = lname as! String //RE ep.13 2mins
//        } else { lastName = "" } //RE ep.13 2mins if no name then set to nothing
//        
//        fullName = firstName + " " + lastName //RE ep.13 3mins
//        
//        
//        if let avat = _dictionary[kAVATAR] { //RE ep.13 2mins check name
//            avatar = avat as! String //RE ep.13 2mins
//        } else { avatar = "" } //RE ep.13 2mins if no name then set to nothing
//        
//        if let agent = _dictionary[kISAGENT] { //RE ep.13 2mins check name
//            isAgent = agent as! Bool //RE ep.13 2mins
//        } else { isAgent = false } //RE ep.13 2mins if no name then set to nothing
//        
//        if let phone = _dictionary[kPHONE] { //RE ep.13 2mins check name
//            phoneNumber = phone as! String //RE ep.13 2mins
//        } else { phoneNumber = "" } //RE ep.13 2mins if no name then set to nothing
//        
//        if let addPhone = _dictionary[kADDPHONE] { //RE ep.13 2mins check name
//            additionalPhoneNumber = addPhone as! String //RE ep.13 2mins
//        } else { additionalPhoneNumber = "" } //RE ep.13 2mins if no name then set to nothing
//        
//        if let favProp = _dictionary[kFAVORIT] { //RE ep.13 2mins check name
//            favoriteProperties = favProp as! [String] //RE ep.13 2mins
//        } else { favoriteProperties = [] } //RE ep.13 2mins if no name then set to nothing
//        
//        
//        if let updated = _dictionary[kUPDATEDAT] { //RE ep.13 2mins
//            updatedAt = dateFormatter().date(from: updated as! String)! //RE ep.13 2mins
//        } else { updatedAt = Date() } //RE ep.13 2mins same as createdAt
//        
//        if let created = _dictionary[kCREATEDAT] { //RE ep.11 11mins we can access the dictionary with the keys, which we can use to save or return the value.
//            createdAt = dateFormatter().date(from: created as! String)! //RE ep.12 4mins this takes a string and returns a date
//        } else { //RE ep.12 4mins if there is no value, dont crash our app
//            createdAt = Date() //RE ep.12 5mins so we just create from current date
//        }
//        
//    } //RE ep.13 4mins this is our initializer when we are getting this dictionary from our firebase. We just want to keep this init func which will create out FUser for us
//    
//    
//    class func currentId() -> String { //RE ep.13 5mins class func that will return our current user id. Difference between class func and a normal func is, normal func needs to be first instantiate the class "let user = FUser() ... user.someFunc". Class func allows you to just call "FUser.someFunc"
//        return Auth.auth().currentUser!.uid //RE ep.13 6mins access our Auth and get our currentUser.uid
//    }
//    
//    class func currentUser() -> FUser? { //RE ep.13 7mins returns our current logged in user, which can be optional so our app wont crash if there is no FUser
//        if Auth.auth().currentUser != nil { //RE ep.13 8mins if there is a user
//            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) { //RE ep.13 8mins access our user defaults. We are saving our userDefaults under current username
//                return FUser.init(_dictionary: dictionary as! NSDictionary) //RE ep.13 9mins So if we have this currentUser we'll create the FUser with dictionary as an NSDictionary
//            }
//        }
//        return nil //RE ep.13 10mins if we dont have user in our UserDefaults, then return nil
//    }
//    
//    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?) -> Void) { //RE ep.14 1mins Firebase will take all these parameters and register our user on a background thread, so main thread doesnt get blocked. So once Firebase is done registering the user, we can call our callback function (completion) which will say "Im finish registering here is what I did"
//        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
//            if let error = error { //RE ep.14 3mins if there's error
//                completion(error) //RE ep.14 3mins call our completion, and heres the error. if there's error then Pass error to our function
//                return //RE ep.14 3mins return so we dont run the rest of the code
//            }
//            
//            guard let currentUserUid = firUser?.user.uid else { return } //RE ep.14 4
//            let fUser = FUser(_objectId: currentUserUid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _firstName: firstName, _lastName: lastName) //RE ep.14 5mins now we have our FUser object, and now we want to save our FUser to our UserDefaults which is what we're checking in our currentUser method
//            
//            //save FUser to UserDefaults so we have it on our device
//            saveUserLocally(fUser: fUser) //RE ep.15 10mins
//            
//            //save FUser to Firebase Database so we can access the user with all the information
//            saveUserInBackground(fUser: fUser) //RE ep.15 14mins
//            
//            completion(error) //RE ep.14 9mins
//        }
//        
//    }
//    
//    
//    
//    class func registerUserWith(phoneNumber: String, verificationCode: String, completion: @escaping (_ error: Error?, _ shouldLogin: Bool) -> Void) { //RE ep.17 1min
//        
//        let verificationID = UserDefaults.standard.value(forKey: kVERIFICATIONCODE) //RE ep.17 2mins //kVERIFICATIONCODE = "firebase_verification" //3min Once our user inputs phone number and request a code, firebase will send the modification code which is not the password code. This code is sent by Firebase in the background to identify if the application is actually running on the device that is requesting the code.
//        
//        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode) //RE ep.17 4mins //Firebase's credential =
//        /*Summary
//         Creates an `FIRAuthCredential` for the phone number provider identified by the verification ID and verification code.
//         
//         Parameters
//         verificationID
//         The verification ID obtained from invoking verifyPhoneNumber:completion:
//         verificationCode
//         The verification code obtained from the user.
//         
//         Returns
//         The corresponding phone auth credential for the verification ID and verification code provided.
//         */
//        Auth.auth().signInAndRetrieveData(with: credentials) { (firUser, error) in //RE ep.17 5mins Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. a Facebook login Access Token, a Google ID Token/Access Token pair, etc.) and returns additional identity provider data.
//            if let error = error { //if there's error put false on completion's shouldLogin parameter
//                completion(error, false) //RE ep.17 6mins
//                return
//            }
//            
//            //check if user is logged in else register
//            fetchUserWith(userId: (firUser?.user.uid)!, completion: { (user) in //RE ep.18 2mins
//                
//                if user != nil && user?.firstName != "" { //RE ep.18 3mins check if user is nil and user has a first name, provides extra protection
//                    
//                    //we have a user, login the user
//                    saveUserLocally(fUser: user!) //RE ep.18 4mins save user in our UserDefaults. We dont need to save in background because we are already getting/fetching the user
//                    completion(error, true) //RE ep.18 call our callback function to exit and finally input the error or shouldLogin to true
//                    
//                    
//                } else { //RE ep.18 4mins we have no user, register the user
//                    let fUser = FUser(_objectId: (firUser?.user.uid)!, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _firstName: "", _lastName: "", _phoneNumber: (firUser?.user.phoneNumber)!) //RE ep.18 6mins so we create a user
//                    
//                    saveUserLocally(fUser: fUser) //RE ep.18 7mins now we have the newly registered user, save it locally and in background
//                    saveUserInBackground(fUser: fUser) //RE ep.18 7mins
//                    completion(error, false) //RE ep.18 7mins pass error which is nil, and shouldLogin = false because we need to finish registering the user. Need a new VC for that
//                    
//                }
//                
//            })
//            
//        }
//        
//    }
//    
//    
//    
//    
//    
//    
//} //end of class
//
////+++++++++++++++++++++++++   MARK: Saving user   ++++++++++++++++++++++++++++++++++
//func saveUserInBackground(fUser: FUser) { //RE ep.15 10mins
//    let ref = firDatabase.child(kUSER).child(fUser.objectId) //RE ep.15 13mins, kUSER = "User". objectId is the user UID
//    ref.setValue(userDictionaryFrom(user: fUser)) //RE ep.15 14mins Database's "User" will have the user's uid as its child, and then set the values of the userDictionary to the child uid/objectId //Overall, creates a reference for our user in our Database
//}
//
////save locally
//func saveUserLocally(fUser: FUser) { //RE ep.15 9mins
//    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER) //RE ep.15 9mins this method takes the user converted to an NSDictionary and puts forKey: kCURRENTUSER
//    UserDefaults.standard.synchronize() //RE ep.15 10mins so it will save our objects to our UserDefaults in background on the device
//}
//
//
//
//
//
////MARK: Helper fuctions
//
//func fetchUserWith(userId: String, completion: @escaping (_ user: FUser?) -> Void) { //RE ep.17 10mins with userId!
//    let ref = firDatabase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId) //RE ep.17 11mins orderedByChild orders all our users using their objectId. And objectId is going to be query equals userId we are passing
//    //queryOrderBy: is used to generate a reference to a view of the data that's been sorted by the values of a particular child key. This method is intended to be used in combination with queryStartingAtValue:, queryEndingAtValue:, or queryEqualToValue:.
//    //queryEqualToValue: is used to generate a reference to a limited view of the data at this location. The FIRDatabaseQuery instance returned by queryEqualToValue: will respond to events at nodes with a value equal to the supplied argument.
//    ref.observeSingleEvent(of: .value) { (snapshot) in //RE ep.17 12mins observe one value only. //.value = Any data changes at a location or, recursively, at any child node.
//        
//        if snapshot.exists() { //RE ep.18 0min if we find a user
//            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! NSDictionary //RE ep.18 1min
//            let user = FUser(_dictionary: userDictionary) //RE ep.18 2mins assign
//            completion(user) //RE ep.18 2mins gives the user in completion
//            
//        } else { //RE ep.18 0min snapshot dont exist
//            completion(nil) //RE ep.18 0min we dont have a user
//        }
//        
//        
//    }
//    
//}
//
//
//func userDictionaryFrom(user: FUser) -> NSDictionary { //RE ep.15 1min take a user and return an NSDictionary
//    
//    let createdAt = dateFormatter().string(from: user.createdAt) //RE ep.15 2mins
//    let updatedAt = dateFormatter().string(from: user.updatedAt) //RE ep.15 2mins
//    
//    return NSDictionary(
//        objects: [user.objectId, createdAt, updatedAt, user.company, user.pushId!, user.firstName, user.lastName, user.fullName, user.avatar, user.phoneNumber, user.additionalPhoneNumber, user.isAgent, user.coins, user.favoriteProperties],
//        forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kCOMPANY as NSCopying, kPUSHID as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kAVATAR as NSCopying, kPHONE as NSCopying, kADDPHONE as NSCopying, kISAGENT as NSCopying, kCOINS as NSCopying, kFAVORIT as NSCopying, ]) //RE ep.15 5mins - 7mins //now this func create and return an NSDictionary
//}
//
//
////RE ep.24 0min method for updating our users in Firebase with any values we want
//func updateCurrentUser(withValues: [String : Any], withBlock: @escaping(_ success: Bool) -> Void) { //RE ep.24 0min will pass a dictionary with an Any value, with running a background thread escaping, pass success type boolean, so we can return if user was updated successfully, no return here so void
//    
//    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil { //RE ep.24 2mins
//        let currentUser = FUser.currentUser()! //RE ep.24 3mins
//        let userObject = userDictionaryFrom(user: currentUser).mutableCopy() as! NSMutableDictionary //RE ep.24 3mins //this makes the normal dictionary a mutable dictionary and specify it as NSMutableDictionary
//        userObject.setValuesForKeys(withValues) //RE ep.24 4mins pass our withValues parameter and to pass it to userObject, now we can save our user to Firebase
//        
//        let ref = firDatabase.child(kUSER).child(currentUser.objectId) //RE ep.24 4mins
//        ref.updateChildValues(withValues) { (error, ref) in //RE ep.24 5mins
//            if error != nil { //RE ep.24 6mins
//                withBlock(false) //RE ep.24 6mins
//                return //RE ep.24 6mins
//            }
//            
//            UserDefaults.standard.set(userObject, forKey: kCURRENTUSER) //RE ep.24 6mins update our user in our UserDefaults
//            UserDefaults.standard.synchronize() //RE ep.24 7mins
//            withBlock(true) //RE ep.24 7mins
//        }
//    }
//    
//}
//
//
//
////MARK: OneSignal Methods
//func updateOneSignalId() { //RE ep.25 0mins
//    if FUser.currentUser() != nil { //RE ep.25 0min check if the user is logged in, otherwise dont do anything that can crash ur app
//        if let pushId = UserDefaults.standard.string(forKey: "OneSignalId") { //RE ep.25 1min check if we have pushId saved in our UserDefaults by AppDelegate
//            setOneSignalId(pushId: pushId) //RE ep.25 3mins
//            
//        } else { //RE ep.25 2min otherwise remove signal id
//            removeOneSignalId() //RE ep.25 3mins
//        }
//        
//    }
//    
//}
//
//func setOneSignalId(pushId: String) { //RE ep.25 2mins this will set our id
//    
//    updateCurrentUserOneSignalId(newId: pushId) //RE ep.25 4mins update/replace with with pushId
//    
//}
//
//func removeOneSignalId() { //RE ep.25 3mins
//    updateCurrentUserOneSignalId(newId: "") //RE ep.25 4mins update/replace with an empty string
//}
//
//func updateCurrentUserOneSignalId(newId: String) { //RE ep.25 3mins
//    print("Updating OneSignal Id with......... \(newId)")
//    updateCurrentUser(withValues: [kPUSHID: newId, kUPDATEDAT: dateFormatter().string(from: Date())]) { (success) in //RE ep.25 4mins call our updateCurrentUser method and update our "pushId" with our OneSignalId, and "updatedAt" with our current date using our dateFormatter method
//        print("One signal id was uupdated - \(success)") //RE ep.25 5mins. Now we can go back to our AppDelegate and call updateOneSignalId in startOneSignal
//    }
//}
//
//
//    
//    
//}
//
