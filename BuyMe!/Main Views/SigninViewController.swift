//
//  SigninViewController.swift
//  BuyMe!
//
//  Created by obss on 20.10.2022.
//

import UIKit
import FirebaseAuth

class SigninViewController: UIViewController {

    var userMail: String = ""
    var userPassword: String = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func createUSerButtonPressed(_ sender: Any) {
     fieldCheck()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSuccesSegue{ // giriş başarılıdır uygulamaya gider
            let viewController = segue.destination as! CategoryCollectionViewController
            viewController.ownerID = "1234"
        }
    }

    
    private func fieldCheck() {
        if let email = self.emailTextField.text, let password = self.passwordTextfield.text { //email ve şifre yaratma zorunluluğu oluşturuyoruz. ikisi birden olmadan ilerlemiyor.
            
            User.registerUser(email: email, password: password) { error in
                if error != nil {
                    ErrorController.alert(alertInfo: "Verification e-mail sended! Please verify your account!", page: self)
                } else {
                    self.prepare(for: UIStoryboardSegue.init(identifier: signinSucces, source: LoginViewController().self, destination: CategoryCollectionViewController().self), sender: (Any).self)
                }
            }
        }
    }
    
    
}
