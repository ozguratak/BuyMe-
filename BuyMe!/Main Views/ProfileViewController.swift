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
     
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var shippingAdressTextField: UITextField!
    @IBOutlet weak var billAdressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var user: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh) , name: Notification.Name(userLoggedIn), object: nil)
        
        User().downloadUserFromFirestore { userArray in
            self.user = userArray
        }
        
    }
    

    @objc func refresh() {
        nameTextField.text = "Çalıştı!"
        lastNameTextField.text = "Çalıştı!"
        shippingAdressTextField.text = "Çalıştı!"
    }

    
}





