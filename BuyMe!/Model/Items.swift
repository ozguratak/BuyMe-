//
//  Items.swift
//  BuyMe!
//
//  Created by obss on 6.10.2022.
//

import Foundation
import UIKit

class Items {
    
    var id: String!
    var categoryID: String!
    var name: String!
    var price: Double!
    var description: String!
    var imageLinks: [String]!

    init() {
   // 08507770541 vodafone  online müşteri hizmetleri telefon numarası.
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[keyObjectID] as? String ?? ""
        categoryID = _dictionary[keyCategoryID] as? String ?? ""
        name = _dictionary[keyName] as? String ?? "Oops! we can't find item :("
        description = _dictionary[keyDescription] as? String
        price = _dictionary[keyPrice] as? Double ?? 0.0
        imageLinks = _dictionary[keyLinks] as? [String] ?? [""]
    }
    
    //MARK: - Save Items
    public func saveItemsToFirestore(_ item: Items) {
        //firebaseReferance fonksiyonumuza erişim verdirerek Itemlerimizi kayıt etmemizi sağlayacak
        firebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
    }
    // id'ye bağlı bir belge yaratmaya çalışıyoruz, bu id bize itemin içeriğini getirecek(document(item.id) açıklaması) ardından veriyi set edeceğiz, setleyeceğimiz veri itemDictionaryFrom adındaki fonksiyon tarafından hazırlanacak ve iteme ait initleri içeren bir "string key-any value" arrayi firestore içerisine set edilecek.

    //MARK: - Helpers
    
    func itemDictionaryFrom(_ item: Items) -> NSDictionary{
        return NSDictionary(objects: [item.id, item.categoryID, item.name, item.description, item.price, item.imageLinks], forKeys: [keyObjectID as NSCopying, keyCategoryID as NSCopying, keyName as NSCopying, keyDescription as NSCopying, keyPrice as NSCopying, keyLinks as NSCopying])
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
}
