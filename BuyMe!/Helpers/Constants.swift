//
//  Constants.swift
//  BuyMe!
//
//  Created by obss on 5.10.2022.
//

import Foundation
//MARK: - Typo hatası yaşamamak için string olarak tanımlanan bazı içerikler ilgili dosya başlığına göre aşağıda listelenmiştir. 

//Firebase Headers
public let keyUserPath = "User"
public let keyCategory = "Category"
public let keyItems = "Items"
public let keyBasket = "Basket"


//Category
public let keyName = "name"
public let keyImageName = "imageName"
public let keyObjectID = "objectID"


//Items
public let keyCategoryID = "categoryID"
public let keyPrice = "price"
public let keyLinks = "imageLinks"
public let keyDescription = "description"
public let itemNotFound = "Not Found Any Item!"
public let itemUploadAdvice = "Maybe you can upload a new item for sale!"

//Basket
public let keyBasketID = "basketID"
public let keyBasketOwnerID = "basketOwnerID"
public let keyBasketItemIDs = "basketItemIDs"


//Cell Keys
public let cellIdentifier = "Cell"
public let itemCell = "TableCell"
public let itemDetailImage = "ImageCell"
public let basketCell = "basketCell"


//Segues
public let itemSegue = "categoryToItem"
public let addItemSegue = "addItemSegue"
public let itemDetail = "itemDetail"


//Alert Strings and Keys
struct AlertKey{
    static let fillMessage = "You didn't filll the all blanks!"
    static let error = "Error"
    static let caution = "Caution!"
    static let ok = "OK!"
    static let connectionError = "No internet connection! Please check your connection and try again."
    static let somethingError = "Oops! something get wrong :("
    static let downloadError = "Images didn't download. We don't know why is happened... May be you should check your connection."
    static let confirmation = "Good news! Item has added to your basket. What do you want to do?"
    static let congrats = "Congrats!"
}

//Links
public let imageStorageLink = "gs://buyme-6b486.appspot.com"


