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
    @IBAction func resendVerifiedMail(_ sender: Any) {
        if Auth.auth().currentUser?.isEmailVerified == false {
            User().resendVerifyMail()
            ErrorController.alert(alertInfo: "Verification mail sended. Please check your e-mail.", page: self)
        } else {
            ErrorController.alert(alertInfo: "Your account has been already verified.", page: self)
        }
        
    }
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
        if emailTextField.text != nil {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!)
            ErrorController.message(page: self,message: "Password reset mail sended.", title: "Nice", action: true) { action in
                action.dismiss(animated: true)
            }
        } else {
            ErrorController.alert(alertInfo: "please fill all the blanks.", page: self)
        }
        
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
                        self.accessLogin()
                        userID = Auth.auth().currentUser!.uid
                        currentEmail = self.emailTextField.text!
                        self.loadingActivityIndicator.isHidden = true
                        self.loadingActivityIndicator.stopAnimating()
                        ErrorController.message(page: self, message: "Verified access. Welcome!", title: "Good News!", action: true) { action in
                            action.dismiss(animated: true)
                        }
                       
                    } else {
                        ErrorController.message(page: self, message: "Your e-mail was not verified. Please check your e-mail.", title: "Oops!", action: true) { action in
                            action.dismiss(animated: true)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.accessLogin()
                            self.loadingActivityIndicator.isHidden = true
                            self.loadingActivityIndicator.stopAnimating()
                        }
                    }
                    
                } else {
                    ErrorController.alert(alertInfo: String(describing: error!), page: self)
                    self.loadingActivityIndicator.isHidden = true
                    self.loadingActivityIndicator.stopAnimating()
                }
            }
        } else {
            ErrorController.alert(alertInfo: "Please fill all the blanks!", page: self)
            self.loadingActivityIndicator.isHidden = true
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
    private func accessLogin() {
        
        let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let appVC = mainSb.instantiateViewController(identifier: loginSuccesSegue)
        
        show(appVC, sender: self)
        
        
    }
      
    private func newUser() {
        
        let user = User()
        
        user.objectID = userID ?? ""
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

}

