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
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0) // içeriğin cell içerisindeki yerleşimini belirleyen constraintler. Cell tamamen görsel kaydıracağı için sıfıra sıfır yaptık.
    private let itemsPerRow: CGFloat = 1 // Her bir satırda kaç item olabileceğini limitledik.
    private let cellHeight: CGFloat = 300.0
    private let cellWidth: CGFloat = 370.0
    
    //MARK: - IBOutlets
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
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
        }
        
    }
    
    //MARK: - IBActions
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButonPressed(_ sender: Any) {
        
        //todo: Login check!
        
        basket.downloadBasketFromFirebase("1234") { basket in
            if basket == nil {
                self.newBasket()
            } else {
                basket?.itemIDs.append(self.item.id)
                self.updateBasket(basket: basket!, withValues: [keyBasketItemIDs : basket!.itemIDs!])
                self.notificationController()
            }
        }
        ErrorController.alert(alertInfo: "Item succesfully added to basket!", page: self)
    }
    private func newBasket() {
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerID = "1234"
        newBasket.itemIDs = [self.item.id]
        
        Basket.shared.saveBasketToFireStore(newBasket)
        
    }
    
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        basket.updateBasket(basket: basket, withValues: withValues, completion: { error in
            if error != nil {
                ErrorController.alert(alertInfo: "Error: \(error)", page: self)
            } else {
                ErrorController.alert(alertInfo: "Item succesfully added to basket!", page: self)
            }
        })
        
    }
    private func notificationController() {
        NotificationCenter.default.post(name: NSNotification.Name(itemAddNotification), object: nil)
        print("Item basketlendi!")
    }
    
    
}
extension ItemsDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource { // Tekrar Notu: Bu aşamada ilk başta görüntüyü cell içerisine getiremedik bu extension çalışmamıştı. bunun nedeni datasource ve delegate'in sayfanın viewı içerisinde dahil edilmemiş olmasıydı. benzer bir görüntü alamama fonksiyonların çalışmama durumu burdan kaynaklı referenceOutlets bağlantısının olmamasından kaynaklanabilir.
    
    func collectionView(_ imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count // if case'in kısa yazılmış versiyonu aslında. buraya bir if case yazıp döndürmek yerine kısaca bunu yazdık. tanımlaması eğer itemImages.count 0 olursa 1 tane cell göster : (else) içeriğin sayısı kadar göster.
        
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

