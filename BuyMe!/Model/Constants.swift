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
public var userID: String? 

//USer
public let keyUserImages = "imageLink"
public let keyUserID = "unknownUser"
public let keyUserPhone = "phoneNumber"
public let keyCurrentUser = "currentUser"
public let keyUserEmail = "email"
public let keyUserName = "name"
public let keyUserLastName = "lastName"
public let keyUserAdress = "fullAdress"
public let keyUserOnBoard = "onBoard"
public let keyUserPurchased = "purchasedItems"
public let keyUserPassword = "password"
public let keyUserBillAdress = "billAdress"

//Orders
public let keyOrderID = "orderID"
public let keyOrderOwnerName = "order owner's name"
public let keyOrderAdress = "adress for shipping"
public let keyOrderBillAdress = "adress for bill"
public let keyOrderPhone = "phone number for order's owner"
public let keyOrderItems = "order item list"

//Cell Keys
public let cellIdentifier = "Cell"
public let itemCell = "TableCell"
public let itemDetailImage = "ImageCell"
public let basketCell = "basketCell"


//Segues
public let itemSegue = "categoryToItem"
public let addItemSegue = "addItemSegue"
public let itemDetail = "itemDetail"
public let appAccess = "categoryView"
public let loginSuccesSegue = "CategoryCollectionViewController"
public let signinPageSegue = "signinViewSegue"
public let signinSucces = "completeSignin"
public let passwordChange = "passwordChange"
public let emailChange = "emailChange"


//Notification Constants
public let itemAddNotification = "ItemAdded"
public let itemAddToCategory = "itemAddToCategory"

public let logOutNotification = "logOutDone"
public let userLoggedIn = "knowingUserLoggedIn"

public var currentEmail = ""

public let checkoutButton = "checkOut"


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
    static let loginError = "User name or Password is invalid! Please check and try again!"
}

//Links
public let imageStorageLink = "gs://buyme-6b486.appspot.com"


