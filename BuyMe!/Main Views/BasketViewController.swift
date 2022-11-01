//
//  BasketViewController.swift
//  BuyMe!
//
//  Created by obss on 14.10.2022.
//

import UIKit
import Foundation

class BasketViewController: UIViewController {
    //MARK: Singletons
    var basket = Basket.shared
    @IBOutlet weak var emptyBasketView: UIView!
    @IBOutlet weak var emptyBasketLabel: UILabel!
    
    
    //MARK: IBOutlets
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var checkButtonOutlet: UIButton!
    @IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
    
    
    //MARK: IBActions
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        firebaseReference(.User).whereField(userID!, isEqualTo: keyUserPurchased).getDocuments { snapShot, error in
            if let error = error {
                print("snapshot indirirken bişeyler oldu: \(String(describing: error))")
            }
            if let snapShot = snapShot {
                let document = snapShot.documents.first
                for item in self.basketItemIDs {
                    document?.setValue(item, forKey: keyUserPurchased)
                }
                self.goToPaymentPage()
            } else {
                print("snapshot dönmedi snapshot nil")
            }
        }
    }
    
    
    var item: Items!
    var defaultBasket: Basket!
    var basketItems: [Items] = []
    var basketItemIDs: [String] = []
    var purchasedItemIDs: [String] = []
    
    var pieceCounter: [String : Int] = [:]
    //MARK: - Refresh Control
    private let refreshControl = UIRefreshControl()
    //MARK: temporary variables
    let ownerID = userID // ownerID eşleşme yapmazsa veriyi çekmez. ownerID doğruluğundan emin olunmalı.
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAccount()
        NotificationCenter.default.addObserver(self, selector: #selector(navigationCenterActivity) , name: Notification.Name(itemAddNotification), object: nil)
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.refreshControl?.isEnabled = true
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        itemTableView.addSubview(refreshControl)
        refresh()
    }
    
    //MARK: - Page refreshing controllers
    @objc func refresh(_ sender: AnyObject) {
        refresh()
    }
    
    private func refresh() {
        refreshControlIndicator.isHidden = false
        refreshControlIndicator.startAnimating()
        Skeleton.startAnimation(outlet: itemTableView.self)
        getBasket()
    }
    
    private func stopRefresh() {
        
        refreshControlIndicator.stopAnimating()
        Skeleton.stopAnimaton(outlet: itemTableView.self)
        refreshControlIndicator.isHidden = true
        refreshControl.endRefreshing()
        
    }
    private func goToPaymentPage() {
        let mainSb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let appVC = mainSb.instantiateViewController(identifier: "PaymentViewController")
        show(appVC, sender: self)
    }
    //MARK: - Check user account
    func checkAccount() {
        if ownerID == "" {
            ErrorController.goBack(alertInfo: "Your account has not verified. Please verify your e-mail and contunie to shopping.", showPage: self, goPage: CategoryCollectionViewController())
        }
    }
    
    
    //MARK: - Get Basket data
    func getBasket() {
        
        basket.downloadBasketFromFirebase(ownerID ?? "") { basket in
            if basket?.itemIDs.isEmpty == false{
                
                self.basketItemIDs.removeAll()
                self.basketItems.removeAll()
                self.basketItemIDs = (basket?.itemIDs)!
                self.defaultBasket = basket!
                print("basket indirildi içinde \(self.basketItemIDs.count) adet item var")
                self.setItemsInBasket()
                
            } else {
                
            }
        }
        
    }
    
    private func basketEmptyState() {
        if basketItems.count != 0 {
            totalAmount.isHidden = false
            itemTableView.isHidden = false
            emptyBasketView.isHidden = true
            emptyBasketLabel.isHidden = true
            
        } else {
            
            totalAmount.isHidden = true
            itemTableView.isHidden = true
            emptyBasketView.isHidden = false
            emptyBasketLabel.isHidden = false
        }
        
    }
    
    //MARK: - Download Items content from DB for listing
    private func setItemsInBasket() {
        
        Items().downloadItemsFromFirebase { (allItems) in
            for item in allItems {
                if self.basketItemIDs.contains(item.id) {
                    self.basketItems.append(item)
                }
            }
            print("\(self.basketItems.count) adet item basket için eklendi...")
            self.totalAmount.text = self.totalAmountCalculate()
            self.itemTableView.reloadData()
        }
        stopRefresh()
    }
    //MARK: - Delete items from basket
    private func deleteItemFromBasket(itemID: String) {
        
        for i in 0..<basketItemIDs.count {
            if itemID == basketItemIDs[i] {
                basketItemIDs.remove(at: i)
                updateBasket(basket: defaultBasket, withValues: [keyBasketItemIDs : basketItemIDs])
                refresh()
                self.basketEmptyState()
                return
            }
        }
    }
    
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        basket.updateBasket(basket: basket, withValues: withValues, completion: { error in
            if error != nil {
                ErrorController.alert(alertInfo: "Error Code: 103", page: self)
            }
        })
    }
    
    // MARK: - Helper functions for UX
    private func totalAmountCalculate() -> String {
        var amount = 0.0
        
        for item in basketItems {
            amount += item.price * Double(itemPieceCalculate()[item.id]!)
            print("toplam sepet tutarı: \(amount)")
        }
        return String(describing: amount)
    }
    
    private func itemPieceCalculate() -> [String : Int] {
        var container: [String] = []
        var counter = 2
        
        for ids in basketItemIDs {
            if container.contains(ids) {
                pieceCounter.updateValue(counter, forKey: ids)
                counter += 1
            } else {
                container.append(ids)
                pieceCounter[ids] = 1
            }
        }
        return pieceCounter
    }
    
    //MARK: - Checout button controls
    private func checkoutButtonStatusUpdate() {
        
        
        if self.basketItems.count != 0 {
            checkButtonOutlet.isEnabled = true
            checkButtonOutlet.backgroundColor = UIColor.systemGreen
            checkButtonOutlet.setTitleColor(.white, for: .normal)
        } else {
            checkButtonOutlet.isEnabled = false
            checkButtonOutlet.backgroundColor = UIColor.systemRed
            checkButtonOutlet.setTitleColor(UIColor.black , for: .normal)
        }
        self.basketEmptyState()
    }
    
    //MARK: - Navigation Center call activity
    @objc func navigationCenterActivity() {
        refresh()
    }
}

//MARK: - TableView görünümleri için delegate ve datasource düenlemeleri

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ itemTableView: UITableView, numberOfRowsInSection section: Int) -> Int { // tableview cell sayısı konfigürasyonu
        
        if !basketItems.isEmpty{
            checkoutButtonStatusUpdate()
            return basketItems.count
        }
        return 0
    }
    
    func tableView(_ itemTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cell konfigürasyonu ve yapılandırması
        
        Skeleton.startAnimation(outlet: itemTableView)
        
        let cell = itemTableView.dequeueReusableCell(withIdentifier: basketCell, for: indexPath) as! BasketItemsTableViewCell
        if !basketItems.isEmpty{
            cell.configure(item: basketItems[indexPath.row], dict: itemPieceCalculate())
            
        } else {
            cell.defaultCell()
        }
        Skeleton.stopAnimaton(outlet: itemTableView)
        return cell
    }
    
    func tableView(_ itemsTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // cell'lerin kaydırılarak table viewdan çıkartılması ve DB'den silinmesi
        let itemID = basketItems[indexPath.row].id!
        var editItemPiece = pieceCounter[basketItems[indexPath.row].id]
        var counter = editItemPiece!
        
        if editingStyle == .delete {
            if editItemPiece! > 1 {
                counter -= 1
                editItemPiece! = pieceCounter.updateValue(counter, forKey: (itemID))!
                basketItems.remove(at: indexPath.row)
                deleteItemFromBasket(itemID: itemID)
                itemsTableView.deleteRows(at: [indexPath], with: .fade)
                
            } else {
                basketItems.remove(at: indexPath.row)
                deleteItemFromBasket(itemID: itemID)
                itemsTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemDetail(basketItems[indexPath.row])
    }
    
    private func showItemDetail(_ item: Items) { //Item id'yi Item detay sayfasına yolladık. Segue kullanmadan storyboardID ile sayfaya push eedeceğiz didselect row at içine itemle çağırabilmek için ayrı fonksiyon olarak yazdık.
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: itemDetail) as! ItemsDetailViewController
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}
