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
var actionState: Bool = false
    
    private func changePassword() {
     
        
        if newPasswordPairing() {
            User().changePassword(newPassword: newPasswordConfirmationTextField.text!, page: self)
           
            ErrorController.message(page: self, message: "Your password changed.", title: "Nice!", action: true) { action  in
                action.dismiss(animated: true)
                action.presentedViewController?.dismiss(animated: true)
               
            }
            
      
        } else {
            ErrorController.message(page: self, message: "New password not paired.", title: "Oops!", action: true) { action in
                action.dismiss(animated: true)
                self.actionState = false
            }
          
        }
      
    }

 
    private func newPasswordPairing() -> Bool {
        if newPasswordTextField.text == newPasswordConfirmationTextField.text && newPasswordConfirmationTextField.text != "" {
            return true
        } else {
            return false
        }
    }
}
