//
//  Items.swift
//  BuyMe!
//
//  Created by obss on 6.10.2022.
//

import Foundation
import UIKit

class Items {
    
    static let shared = Items()
    
    var id: String!
    var categoryID: String!
    var name: String!
    var stock: Int!
    var price: Double!
    var description: String!
    var imageLinks: [String]!

    init() {
 
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[keyObjectID] as? String ?? ""
        categoryID = _dictionary[keyCategoryID] as? String ?? ""
        name = _dictionary[keyName] as? String ?? "Oops! we can't find item :("
        description = _dictionary[keyDescription] as? String
        price = _dictionary[keyPrice] as? Double ?? 0.0
        imageLinks = _dictionary[keyLinks] as? [String] ?? [""]
        stock = _dictionary[keyStock] as? Int ?? 0
    }
    
    //MARK: - Save Items
    public func saveItemsToFirestore(_ item: Items) {
        firebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
    }
    

    //MARK: - Helpers
    
    func itemDictionaryFrom(_ item: Items) -> NSDictionary {
        return NSDictionary(objects: [item.id, item.categoryID, item.name, item.description, item.price, item.imageLinks, item.stock], forKeys: [keyObjectID as NSCopying, keyCategoryID as NSCopying, keyName as NSCopying, keyDescription as NSCopying, keyPrice as NSCopying, keyLinks as NSCopying, keyStock as NSCopying])
    }
    
    //MARK: - Downloading Items from firebase
    
    func downloadItemsFromFirebase(completion: @escaping (_ itemsArray: [Items]) -> Void) {
        
        var itemsArray: [Items] = []
        
        firebaseReference(.Items).getDocuments { snapshot, error in
            guard let snapshot = snapshot
        else {
            completion(itemsArray)
            return
        }
        
        if !snapshot.isEmpty {
            for itemsDict in snapshot.documents {
                itemsArray.append(Items(_dictionary: itemsDict.data() as NSDictionary))
            }
        }
                
        completion(itemsArray)
    }
}
    func deleteItemFromFirebase(itemID: String) {
        firebaseReference(.Items).document(itemID).delete { error in
            if error != nil {
                print("deleting error!")
            }
        }
    }
}
