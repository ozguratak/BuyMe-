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
    var phoneNumber: String = ""
    var profileImageLinks: [String] = []
    
    var purchasedItemIds: [String] = []
    var fullAdress: String = ""
    var billAdress: String = ""
    var onBoard: Bool = false
    
    
    //MARK: - Initiliazers
    init () {
        
    }
    
    init (_objectId: String, _eMail: String) {
        
        objectID = _objectId
        email = _eMail
        firstName = ""
        lastName = ""
        fullAdress = ""
        billAdress = ""
        onBoard = false
        purchasedItemIds = []
        phoneNumber = ""
        profileImageLinks = []
        
    }
    
    init (_dictionary: NSDictionary) {
        
        fullAdress = _dictionary[keyUserAdress] as! String
        billAdress = _dictionary[keyUserBillAdress] as! String
        phoneNumber = _dictionary[keyUserPhone] as! String
        
        
        if let image = _dictionary[keyUserImages] {
            profileImageLinks = image as? [String] ?? []
        } else {
            profileImageLinks = []
        }
        
        if let mail = _dictionary[keyUserEmail] {
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
        
        if let oBoard = _dictionary[keyUserOnBoard] {
            onBoard = oBoard as! Bool
        } else {
            onBoard = false
        }
        
        if let pItems = _dictionary[keyUserPurchased] {
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
        var result: User?
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: keyCurrentUser) {
                result = User.init(_dictionary: dictionary as! NSDictionary)
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return result
    }
    
    //MARK: - User login and register functions
    
    class func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ verified: Bool, _ Id: String) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { ( authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    userID = Auth.auth().currentUser!.uid
                    //download user firebase
                    completion(error, true, userID ?? "")
                } else {
                    authDataResult!.user.sendEmailVerification()
                    
                    completion(error, false, "")
                }
            } else {
                completion(error, false, "")
            }
        }
    }
    
    class func registerUser(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            
            completion(error)
            if error == nil {
                User().createUserSet(id: currentId(), mail: email)
                authDataResult!.user.sendEmailVerification { error in
                    print("auth e mail verification error : \(String(describing: error))")
                }
                
            } else {
                print("user creating error: \(String(describing: error))")
            }
        }
        
        
    }
    
    class func logOutUser(page: UIViewController) {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: NSNotification.Name(logOutNotification) , object: nil)
            let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let appVC = mainSb.instantiateViewController(identifier: "LoginViewController")
            page.show(appVC, sender: self)
        }
        catch {
            ErrorController.alert(alertInfo: "something get wrong!", page: page)
        }
    }
}

extension User {
    func userDictionaryFrom(_ user: User) -> NSDictionary {
        return NSDictionary(objects: [user.email, user.firstName, user.lastName, user.fullAdress, user.billAdress, user.objectID, user.purchasedItemIds, user.onBoard, user.password, user.phoneNumber, user.profileImageLinks], forKeys: [keyUserEmail as NSCopying, keyUserName as NSCopying, keyUserLastName as NSCopying, keyUserAdress as NSCopying, keyUserBillAdress as NSCopying, keyUserPath as NSCopying, keyUserPurchased as NSCopying, keyUserOnBoard as NSCopying, keyUserPassword as NSCopying, keyUserPhone as NSCopying, keyUserImages as NSCopying])
    }
    
    func saveUserToFirestore(_ user: User) {
        firebaseReference(.User).document(String(describing: user.objectID)).setData(userDictionaryFrom(user) as! [String : Any])
    }
    
    func downloadUserFromFirestore(completion: @escaping (_ userArray: [User]) -> Void) {
        
        var userArray: [User] = []
        
        firebaseReference(.User).getDocuments { snapshot, error in
            guard let snapshot = snapshot
            else {
                completion(userArray)
                return
            }
            
            if !snapshot.isEmpty {
                for usersDict in snapshot.documents {
                    userArray.append(User(_dictionary: usersDict.data() as NSDictionary))
                }
            }
            completion(userArray)
        }
    }
    
    
    func createUserSet(id: String, mail: String) {
        let user = User(_objectId: id, _eMail: mail)
        self.saveUserToFirestore(user)
    }
    
    func updateUserInformations(userID: String, name: String, lastName: String, billAdress: String, shippingAdress: String, phone: String, profileImage: [UIImage?]) {
        
        let user = User()
        
        user.objectID = userID
        user.email = currentEmail
        user.firstName = name
        user.lastName = lastName
        user.fullAdress = shippingAdress
        user.billAdress = billAdress
        user.onBoard = true
        user.phoneNumber = phone
        
        if profileImage.count > 0 {
            
            uploadImages(images: profileImage, imageFileName: "ProfileImages", itemID: userID) { (imageLinkArray) in
                user.profileImageLinks = imageLinkArray
                self.saveUserToFirestore(user)
            }
            
        } else {
            self.saveUserToFirestore(user)
        }
    }
    
    func changePassword(newPassword: String, page: UIViewController) {
        let user = User()
        Auth.auth().currentUser?.reload()
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { error in
            if error != nil {
                ErrorController.alert(alertInfo: "An error occured while changing the password!", page: page)
            } else {
                user.objectID = userID ?? ""
                user.password = newPassword
                self.saveUserToFirestore(user)
                
            }
        })
    }
    
    func changeMail(newMail: String, page: UIViewController) {
        let user = User()
        Auth.auth().currentUser?.reload()
        Auth.auth().currentUser?.updateEmail(to: newMail, completion: { error in
            if error != nil {
                ErrorController.alert(alertInfo: "An error occurred while changing the email", page: page)
            } else {
                user.objectID = userID ?? ""
                user.email = newMail
                self.saveUserToFirestore(user)
            }
        })
    }
    
    func resendVerifyMail() {
        let user = Auth.auth().currentUser
        user?.reload()
        if user?.isEmailVerified == false {
            user?.sendEmailVerification()
            
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete()
    }
}

