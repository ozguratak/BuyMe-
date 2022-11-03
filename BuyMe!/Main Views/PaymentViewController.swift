//
//  PaymentViewController.swift
//  BuyMe!
//
//  Created by obss on 1.11.2022.
//

import UIKit

class PaymentViewController: UIViewController {
    //MARK: Singleton
    let order = Order.shared
    
    //MARK: - Variables
    var totalAmount: String!
    var itemIds: [String] = []
    
    var itemList: [String : Int] = [:]
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var cardOwnerName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cardExpirationDate: UITextField!
    @IBOutlet weak var cardCVV: UITextField!
    
    
    //MARK: - IBActions
    @IBAction func paymentButtonPressed(_ sender: Any) {
        newOrder()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDictMaker()
        // Do any additional setup after loading the view.
    }
    
    private func newOrder() {
        
        let newOrder = Order()
        newOrder.orderID = UUID().uuidString
        newOrder.orderOwnerID = userID
        newOrder.items = self.itemList
        newOrder.totalAmount = Double(self.totalAmount)
        newOrder.purchaseStatus = true
        
        order.saveOrderToFirestore(newOrder)
        
    }

    private func itemDictMaker() {
        var newValue: Int = 1
        for item in itemIds {
            if itemList[item] != nil {
                itemList[item] = newValue + 1
                newValue += 1
            } else {
                itemList[item] = 1
            }
            print(itemList)
        }
    }
    
    private func orderTime() {
        
    }
    
}
