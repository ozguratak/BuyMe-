//
//  ProfileViewController.swift
//  BuyMe!
//
//  Created by obss on 24.10.2022.
//
import Foundation
import UIKit

class ProfileViewController: UIViewController {

    
    var objectID = userID
    var purchasedItems: [String] = []
    
    @IBOutlet weak var profileImage: UIButton!
    
    @IBAction func deleteAccount(_ sender: Any) {
    }
    
    @IBAction func profileImageChangeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        User.logOutUser(page: self)
    }
    
    @IBAction func passwordChangeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: passwordChange, sender: nil)
    }
    @IBAction func emailChangeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: emailChange, sender: nil)
    }
    @IBAction func sameAddressButtonPressed(_ sender: Any) {
        if shippingAdressTextField.text != nil {
            billAdressTextField.text = shippingAdressTextField.text
        }
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        updateUserInformations()
        setupUI()
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var shippingAdressTextField: UITextField!
    @IBOutlet weak var billAdressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    var currentUser: User?
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh) , name: Notification.Name(userLoggedIn), object: nil)
    }
    
    
    @objc func refresh() {
     setupUI()
        presentedViewController?.reloadInputViews()
    }
    
    func downloadCurrentUser() {
        User().downloadUserFromFirestore { userArray in
            if userArray.isEmpty != true {
                for user in userArray {
                    if user.email == currentEmail {
                        self.currentUser = user
                        return
                    }
                }
            } else {
                ErrorController.alert(alertInfo: "user indirilemedi.", page: self)
            }
        }
    }
    
    private func setupUI() {
        if User.currentUser()?.onBoard != nil {
            
            nameTextField.placeholder = "Name"
            lastNameTextField.placeholder = "Last Name"
            phoneTextField.placeholder = "Phone Number"
            shippingAdressTextField.placeholder = "Shipping Adress"
            billAdressTextField.placeholder = "Bill Adress"
        } else {
            downloadCurrentUser()
            
            nameTextField.placeholder = currentUser?.firstName
            lastNameTextField.placeholder = currentUser?.lastName
            phoneTextField.placeholder = currentUser?.phoneNumber
            shippingAdressTextField.placeholder = currentUser?.fullAdress
            billAdressTextField.placeholder = currentUser?.billAdress
        }
    }
    
    private func updateUserInformations() {
        if nameTextField.text != nil && lastNameTextField.text != nil && billAdressTextField.text != nil && shippingAdressTextField.text != nil && phoneTextField.text != nil {
            User().updateUserInformations(userID: User.currentId(), name: nameTextField.text!, lastName: lastNameTextField.text!, billAdress: billAdressTextField.text!, shippingAdress: shippingAdressTextField.text!, phone: phoneTextField.text!)
            self.message(message: "Profile succesfully updated!", title: "Good!", action: true) { action in
                action.dismiss(animated: true)
            }
           
        } else {
            ErrorController.alert(alertInfo: "Please confirm all blanks!", page: self)
        }
       
    }
    private func message(message: String, title: String, action: Bool, completion: @escaping (_ action: UIAlertController) -> Void) {
        
        let notificationVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if action {
                self.present(notificationVC, animated: true)
        }
        completion(notificationVC)
        
    }
        
    

    
}





