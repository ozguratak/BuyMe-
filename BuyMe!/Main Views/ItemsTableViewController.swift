//
//  ItemsTableViewController.swift
//  BuyMe!
//
//  Created by obss on 6.10.2022.
//

/* MARK: - TODO LIST:
 
 item ekleyip geri dönünce içerik update olmuyor!
 
 */

import UIKit

class ItemsTableViewController: UITableViewController {
    var items = Items.shared
    var skeleton = Skeleton.shared 
    var category: Category!
    var itemsArray: [Items] = []
    var itemsForShow: [Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !itemsForShow.isEmpty{
            return itemsForShow.count
        }
        return 0
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Skeleton.startAnimation(outlet: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! TableViewCell
        if !itemsForShow.isEmpty {
            cell.cellConfigure(itemsForShow[indexPath.row])
        } else {
            cell.defaultCell()
        }
        Skeleton.stopAnimaton(outlet: tableView)
        return cell
    }
    
    //MARK: - Helpers & Downloading
    func loadItems() {
        
        items.downloadItemsFromFirebase { (allItems) in
            self.itemsArray = allItems
            self.selectionShowItems()
            self.tableView.reloadData()
            
        }
    }
    private func selectionShowItems(){
        for item in self.itemsArray{
            if item.categoryID == self.category.id {
                self.itemsForShow.append(item)
            }
        }
    }
    
    // MARK: - Navigation
    
    private func showItemDetail(_ item: Items) { //Item id'yi Item detay sayfasına yolladık. Segue kullanmadan storyboardID ile sayfaya push eedeceğiz didselect row at içine itemle çağırabilmek için ayrı fonksiyon olarak yazdık.
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: itemDetail) as! ItemsDetailViewController
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemDetail(itemsForShow[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Category id'yi ekle butonu aracılığı ile açılan item ekleme sayfasına passlıyoruz böylece bu veri ile yeni bir container yaratacağız Category > Items olacak.
        if segue.identifier == addItemSegue {
            let vc = segue.destination as! ItemAddViewController
            vc.category = category!
        }
    }
}
