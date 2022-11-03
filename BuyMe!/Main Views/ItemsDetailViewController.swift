//
//  ItemsDetailViewController.swift
//  BuyMe!
//
//  Created by obss on 11.10.2022.
//

import UIKit

class ItemsDetailViewController: UIViewController {
    
    var basket = Basket.shared
    
    //MARK: - Vars
    var item: Items!
    var itemImages: [UIImage] = []
    var pieceOfItemToBasket: Int = 1
    var canBePurchased: Bool = false
    
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0) // içeriğin cell içerisindeki yerleşimini belirleyen constraintler. Cell tamamen görsel kaydıracağı için sıfıra sıfır yaptık.
    private let itemsPerRow: CGFloat = 1 // Her bir satırda kaç item olabileceğini limitledik.
    private let cellHeight: CGFloat = 300.0
    private let cellWidth: CGFloat = 370.0
    
    //MARK: - IBOutlets
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pieceLabel: UILabel!
    @IBOutlet weak var stockOfItem: UILabel!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction)) // bir önceki sayfaya dönme iconunu kendimiz yeniden şekillendirdik ve bir fonksiyon atadık.
        
        downloadPictures()
        setupUI()
    }
    
    //MARK: - Download Pictures
    
    private func downloadPictures(){
        if item != nil && item.imageLinks != nil {
            
            downloadImagesFromFirestore(imageUrls: item.imageLinks) { images in
                if images.count > 0 {
                    self.itemImages = images as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        if item != nil {
            self.title = item.name
            itemTitle.text = item.name
            itemDescription.text = item.description
            itemPrice.text = Helper.currencyConverter(value: item.price)
            stockControl()
        }
        
    }
    
    //MARK: - IBActions
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Stock
    func stockControl() {
        if item.stock > 10 {
            self.canBePurchased = true
            self.stockOfItem.text = "+10"
        } else if item.stock == 0 {
            self.canBePurchased = false
            self.stockOfItem.text = "Out of stock!"
            self.stockOfItem.textColor = .systemGray
        } else if item.stock <= 2 {
            self.canBePurchased = true
            self.stockOfItem.text = String(describing: item.stock!)
            self.stockOfItem.textColor = .systemRed
        } else if item.stock <= 10 {
            self.canBePurchased = true
            self.stockOfItem.text = String(describing: item.stock!)
        }
        
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        if canBePurchased{
            if pieceOfItemToBasket > 1{
                pieceOfItemToBasket -= 1
                pieceLabel.text = String(describing: pieceOfItemToBasket)
            }
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        if canBePurchased{
            if  pieceOfItemToBasket < 10 {
                pieceOfItemToBasket += 1
                pieceLabel.text = String(describing: pieceOfItemToBasket)
            } else if pieceOfItemToBasket == 10 {
                pieceLabel.text = String(describing: pieceOfItemToBasket)
                ErrorController.alert(alertInfo: "You can add max 10 piece in one time.", page: self)
            }
        }
    }
    
    @IBAction func addButonPressed(_ sender: Any) {
        
        if canBePurchased {
            basket.downloadBasketFromFirebase(userID ?? "") { basket in
                if basket == nil {
                    self.newBasket()
                } else {
                    for _ in 0...self.pieceOfItemToBasket - 1 {
                        basket?.itemIDs.append(self.item.id)
                        self.updateBasket(basket: basket!, withValues: [keyBasketItemIDs : basket!.itemIDs!])
                        NotificationCenter.default.post(name: NSNotification.Name(itemAddNotification), object: nil)
                    }
                }
            }
            ErrorController.alert(alertInfo: "Item succesfully added to basket!", page: self)
        } else {
            ErrorController.alert(alertInfo: "Item out of stock!", page: self)
        }
        
        
    }
    
    //MARK: Add to basket
    private func newBasket() {
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerID = userID
        newBasket.itemIDs = [self.item.id]
        
        Basket.shared.saveBasketToFireStore(newBasket)
        
    }
    
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        basket.updateBasket(basket: basket, withValues: withValues, completion: { error in
            if error != nil {
                ErrorController.alert(alertInfo: "Error: \(String(describing: error))", page: self)
            } else {
                ErrorController.alert(alertInfo: "Item succesfully added to basket!", page: self)
            }
        })
        
    }
    
}
extension ItemsDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count 
    }
    
    func collectionView(_ imageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: itemDetailImage, for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            cell.generateCell(itemImage: itemImages[indexPath.row])
        } else {
            cell.generateCell(itemImage: UIImage(named: "imagePlaceholder")!)
        }
        return cell
    }
}

extension ItemsDetailViewController: UICollectionViewDelegateFlowLayout { // collecitonView akış yapısı hücre boyutları belirleme fonksiyonları
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let availableWidth = collectionView.frame.width - sectionInsets.left // genişliğin ne olacağını bilmiyoruz o yüzden ekran ölçüsünden verdiğimiz paddingSpace'i çıkıyoruz
        collectionView.isPagingEnabled = true
        
        
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

