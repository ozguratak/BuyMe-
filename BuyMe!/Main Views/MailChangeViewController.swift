//
//  MailChangeViewController.swift
//  BuyMe!
//
//  Created by obss on 25.10.2022.
//

import UIKit

class MailChangeViewController: UIViewController {

    @IBOutlet weak var defaultEmailTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newEmailConfirmTextField: UITextField!
    
    
    @IBAction func changeButtonPressed(_ sender: Any) {
        changeMailAdress()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    private func changeMailAdress() {
        if newMailPairing() {
            User().changeMail(newMail: newEmailConfirmTextField.text!, page: self)
        }
    }

    private func newMailPairing() -> Bool {
        if newEmailTextField.text == newEmailConfirmTextField.text && newEmailTextField != nil {
            return true
        } else {
            return false
        }
    }
  
}
