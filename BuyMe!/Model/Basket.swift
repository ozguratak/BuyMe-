//
//  Basket.swift
//  BuyMe!
//
//  Created by obss on 14.10.2022.
//

import Foundation
import UIKit

class Basket {
    //singleton
    static let shared = Basket()
    
    var id: String!
    var ownerID: String!
    var itemIDs: [String]!
    
    init () {
        
    }
    
    init (_dictionary: NSDictionary) {
        id = _dictionary[keyBasketID] as? String
        ownerID = _dictionary[keyBasketOwnerID] as? String
        itemIDs = _dictionary[keyBasketItemIDs] as? [String]
    }
    
    //MARK: - Saving Basket to Database
    func saveBasketToFireStore(_ basket: Basket) {
        firebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
        
    }
    //MARK: - Update Basket
    func updateBasket(basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
        firebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
            completion(error)
        }
    }
    
    func deleteBasket(_ basket: Basket) {
        firebaseReference(.Basket).document(basket.id).delete { error in
            if error != nil {
                print("deleting error \(error!)")
            }
        }
    }
    //MARK: - Download Basket From Database
    func downloadBasketFromFirebase(_ ownerID: String, completion: @escaping (_ basket: Basket?) -> Void) {
        firebaseReference(.Basket).whereField(keyBasketOwnerID, isEqualTo: ownerID).getDocuments { snapShot, error in
            
            guard let snapShot = snapShot else {
                completion(nil)
                return
            }
            if !snapShot.isEmpty && snapShot.documents.count > 0{
                let basket = Basket(_dictionary: snapShot.documents.first!.data() as NSDictionary)
                completion(basket)
            } else {
                completion(nil)
            }
        }
    }
    
    func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
        return NSDictionary(objects: [basket.id, basket.ownerID, basket.itemIDs], forKeys: [keyBasketID as NSCopying, keyBasketOwnerID as NSCopying, keyBasketItemIDs as NSCopying])
    }
    
}
