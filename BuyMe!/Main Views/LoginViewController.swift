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
            User.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!) { error, authData, ID  in
                if error == nil {
                    
                    if authData == true {
                        
                        self.accessLogin()
                        
                        self.message(message: "Access verified", title: "Good News!", action: true)
                    } else {
                        
                        self.accessLogin()
                        
                        self.message(message: "Your e-mail was not verified.", title: "Ooops!", action: true)
                    }
                    
                } else {
                    ErrorController.alert(alertInfo: String(describing: error!), page: self)
                }
            }
        } else {
            ErrorController.alert(alertInfo: "Please fill all the blanks!", page: self)
        }
    }
    
    private func accessLogin() {
        
        let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let appVC = mainSb.instantiateViewController(identifier: loginSuccesSegue)
        
        show(appVC, sender: self)
        
        
    }
    
    private func message(message: String, title: String, action: Bool) {
        
        let notificationVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(notificationVC, animated: true)
        if action {
            notificationVC.dismiss(animated: true)
        }
    }
}

