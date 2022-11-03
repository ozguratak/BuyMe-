//
//  Orders.swift
//  BuyMe!
//
//  Created by obss on 3.11.2022.
//

import Foundation
class Order {
    static let shared = Order()
    
    var items: [String : Int] = [:]
    var totalAmount: Double!
    var purchaseStatus: Bool!
    var orderID: String?
    var orderOwnerID: String?
    var orderTime: String?
    
    init () {
        
    }
    
    init (_ orderId: String) {
        orderID = orderId
        orderOwnerID = userID
        items = ["":0]
        totalAmount = 0.0
        purchaseStatus = false
        orderTime = ""
    }
    
    init (_dictionary: NSDictionary) {
        orderID = _dictionary[keyOrderID] as? String
        orderOwnerID = _dictionary[keyOrderOwnerID] as? String
        purchaseStatus = _dictionary[keyOrderPurchaseStatus] as? Bool
        totalAmount = _dictionary[keyOrderTotal] as? Double
        items = _dictionary[keyOrderItems] as! [String : Int]
        orderTime = _dictionary[keyOrderTime] as? String
    }
    
    func orderDictionaryFrom(_ order: Order) -> NSDictionary {
        return NSDictionary(objects: [order.orderID!, order.orderOwnerID, order.totalAmount!, order.purchaseStatus!, order.items, order.orderTime], forKeys: [keyOrderID as NSCopying, keyOrderOwnerID as NSCopying, keyOrderTotal as NSCopying, keyOrderPurchaseStatus as NSCopying, keyOrderItems as NSCopying, keyOrderTime as NSCopying])
    }
    
    func saveOrderToFirestore(_ order: Order) {
        firebaseReference(.Order).document(order.orderID!).setData(orderDictionaryFrom(order) as! [String : Any])
    }
    
    func deleteOrder(_ order: Order) {
        firebaseReference(.Order).document(order.orderID!).delete { error in
            if let error = error {
                print("Order silinirken hata oluştu: \(String(describing: error))")
            }
        }
    }
    func updateOrder(order: Order, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
        firebaseReference(.Order).document(order.orderID!).updateData(withValues) { error in
            if error == nil {
                completion(error)
            }
        }
    }
    
}
