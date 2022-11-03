//
//  PaymentViewController.swift
//  BuyMe!
//
//  Created by obss on 1.11.2022.
//

import UIKit

class PaymentViewController: UIViewController {
    //MARK: - Variables
    var totalAmount: String!
    var itemIds: [String] = []
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var cardOwnerName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cardExpirationDate: UITextField!
    @IBOutlet weak var cardCVV: UITextField!
    
    
    //MARK: - IBActions
    @IBOutlet weak var paymentButtonPressed: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
