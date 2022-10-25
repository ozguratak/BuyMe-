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
    
    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordEyeOutlet: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    //IBActions
    @IBAction func passwordEyePressed(_ sender: Any) {
        if passwordTextField.isSecureTextEntry == true {
            
            passwordTextField.isSecureTextEntry = false
            passwordEyeOutlet.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
            
        } else {
            
            passwordTextField.isSecureTextEntry = true
            passwordEyeOutlet.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }
        
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginActions()
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        showSigninPage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        emailTextField.text = "test.user74@yahoo.com"
        passwordTextField.text = "123456"
        loadingActivityIndicator.isHidden = true
    }
  
    private func showSigninPage() {
        performSegue(withIdentifier: signinPageSegue, sender: nil)
    }
    
    private func loginActions() {
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
        if emailTextField.text != nil && passwordTextField.text != nil {
            User.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!) { error, authData, ID  in
                if error == nil {
                    
                    if authData == true {
                        self.message(message: "Verified access. Welcome!", title: "Good News!", action: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            
                            self.accessLogin()
                            userID = Auth.auth().currentUser!.uid
                            currentEmail = self.emailTextField.text!
                            self.loadingActivityIndicator.isHidden = true
                            self.loadingActivityIndicator.stopAnimating()
                        }
                    } else {
                        self.message(message: "Your e-mail was not verified. Please check your e-mail.", title: "Ooops!", action: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.accessLogin()
                            self.loadingActivityIndicator.isHidden = true
                            self.loadingActivityIndicator.stopAnimating()
                        }
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
      
    private func newUser() {
        
        let user = User()
        
        user.objectID = userID
        user.firstName = "Your Name"
        user.lastName = "Your Lastname"
        user.fullAdress = "Your Shipping Adress"
        user.billAdress = "Your Bill Adress"
        user.email = emailTextField.text!
        user.password = passwordTextField.text!
        user.onBoard = false
        user.purchasedItemIds = []
        
        User().saveUserToFirestore(user)
    }
    
    private func updateUser() {
        //user: User, withValues: [String : Any]
        
        print("!!!USER ZATEN KAYITLI!!!!")
        
    }
}

