//
//  PasswordChangeViewController.swift
//  BuyMe!
//
//  Created by obss on 25.10.2022.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        
        changePassword()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func changePassword() {
        if newPasswordPairing() {
            User().changePassword(newPassword: newPasswordConfirmationTextField.text!, page: self)
        }
    }
 
    private func newPasswordPairing() -> Bool {
        if newPasswordTextField.text == newPasswordConfirmationTextField.text && newPasswordConfirmationTextField != nil {
            return true
        } else {
            return false
        }
    }
}
