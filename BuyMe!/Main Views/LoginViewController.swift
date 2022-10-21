//
//  LoginViewController.swift
//  BuyMe!
//
//  Created by obss on 20.10.2022.
//

import UIKit
import Foundation
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var ownerID: String = ""
   
    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    //IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
       loginActions()
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
     showSigninPage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func showSigninPage() {
        performSegue(withIdentifier: signinPageSegue, sender: nil)
    }
    
    private func loginActions() {
        if emailTextField.text != nil && passwordTextField.text != nil {
            User.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!) { error, authData in
                if error == nil {
                    self.ownerID = Auth.auth().currentUser!.uid
                    self.accessLogin()
                } else {
                    ErrorController.alert(alertInfo: "Your e-mail has not verified please check your e-mail!", page: self)
                }
            }
        } else {
            ErrorController.alert(alertInfo: "Please fill all the blanks!", page: self)
        }
    }
    
    private func accessLogin() {
        let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)            // 1
               let thirdVC = mainSb.instantiateViewController(identifier: loginSuccesSegue)   // 2
               show(thirdVC, sender: self)
    }
}

