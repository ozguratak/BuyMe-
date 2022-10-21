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
    
    static let ownerID = "1234"
    
    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    //IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
       
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
     showSigninPage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSuccesSegue { // giriş başarılıdır uygulamaya gider
            statusCheck()
            if let viewController = segue.destination as? CategoryCollectionViewController {
                viewController.ownerID = Auth.auth().currentUser?.uid
                viewController.navigationController?.pushViewController(UIViewController.init(nibName: String(describing: CategoryCollectionViewController.self), bundle: nil), animated: true)
            } else {
                ErrorController.alert(alertInfo: "something get wrong", page: self)
            }
        }
    }
    
    private func statusCheck() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    ErrorController.alert(alertInfo: "\(error)", page: self!)
                } else {
                    self?.navigationController?.performSegue(withIdentifier: loginSuccesSegue, sender: self?.loginButtonPressed(_:))
                }
            }
        }
    }
    private func showSigninPage() {
        let signinPage = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: signinPageSegue)
        
        self.present(signinPage, animated: true, completion: nil)
    }
}

