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
    let basket = Basket.shared
    
    //MARK: - Variables
    var totalAmount: String!
    var itemIds: [String] = []
    var currentBasket: Basket?
    
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
    //MARK: - Order creating
    private func newOrder() {
        
        let newOrder = Order()
        
        newOrder.orderID = UUID().uuidString
        newOrder.orderOwnerID = userID
        newOrder.items = self.itemList
        newOrder.totalAmount = Double(self.totalAmount)
        newOrder.purchaseStatus = true
        newOrder.orderTime = orderTime()
        
        order.saveOrderToFirestore(newOrder)
        User().updatePurchaseList(orderID: newOrder.orderID!)
        basket.deleteBasket(currentBasket!)
        
        NotificationCenter.default.post(name: NSNotification.Name(paymentSuccess), object: nil)
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
    
    private func orderTime() -> String{
        let today = Date()
        let hours   = (Calendar.current.component(.hour, from: today))
        let minutes = (Calendar.current.component(.minute, from: today))
        let seconds = (Calendar.current.component(.second, from: today))
        let day = (Calendar.current.component(.day, from: today))
        let month = (Calendar.current.component(.month, from: today))
        let year = (Calendar.current.component(.year, from: today))
        let orderTime = "\(day)/" + "\(month)/" + "\(year)" + " - " + "\(hours):" + "\(minutes):" + "\(seconds)"
        return orderTime
    }

    
}
