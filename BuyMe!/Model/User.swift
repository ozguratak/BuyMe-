//
//  User.swift
//  BuyMe!
//
//  Created by obss on 21.10.2022.
//

import Foundation
import FirebaseAuth


class User {
    
    var objectID: String = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    
    var purchasedItemIds: [String] = []
    var fullAdress: String = ""
    var onBoard: Bool = false
    
    //MARK: - Initiliazers
    
    init (_objectId: String, _eMail: String, _uFirstName: String, _uLastName: String) {
        
        objectID = _objectId
        email = _eMail
        firstName = _uFirstName
        lastName = _uLastName
        fullAdress = ""
        onBoard = false
        purchasedItemIds = []
        
    }
    
    init (_dictionary: NSDictionary) {
    objectID = _dictionary[keyObjectID] as! String
        
        if let mail = _dictionary[keyEmail] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fName = _dictionary[keyUserName] {
            firstName = fName as! String
        } else {
            firstName = ""
        }
        
        if let lName = _dictionary[keyUserLastName] {
            lastName = lName as! String
        } else {
            lastName = ""
        }
        
        if let oBoard = _dictionary[keyOnBoard] {
            onBoard = oBoard as! Bool
        } else {
            onBoard = false
        }
        
        if let pItems = _dictionary[keyPurchased] {
            purchasedItemIds = pItems as! [String]
        } else {
            purchasedItemIds = []
        }
    }
    
    //MARK: - Return Current User
    class func currentId() -> String {
      return  Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
         
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: keyCurrentUser) {
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //MARK: - User login and register functions
    
    class func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ verified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { ( authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    //download user firebase
                    completion(error, true)
                } else {
                    print("email was not verified!")
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    class func registerUser(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            
            completion(error)
            if error == nil {
                authDataResult!.user.sendEmailVerification { error in
                    print("auth e mail verification error : \(String(describing: error))")
                }
        }
    }
}
    
}
