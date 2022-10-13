//
//  CategoryCollectionViewController.swift
//  BuyMe!
//
//  Created by obss on 5.10.2022.
//

import UIKit


class CategoryCollectionViewController: UICollectionViewController {

    //MARK: - Constants
    var categoryArray: [Category] = []
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0) // İçerik ölçüsü limitleme
    private let itemsPerRow: CGFloat = 3 // Her bir satırda kaç item olabileceğini limitledik.
    
    //MARK: - View's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      //  createCategorySet() //DATABASE TEMİZLENDİKTEN SONRA YENİ BİR KATEGORİ GİRİŞİ İÇİN AKTİF EDİLMELİ HARİCİNDE COMMENT KALMALI!!!!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        loadCategories()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        Skeleton.startAnimation(outlet: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.generateCell(categoryArray[indexPath.row])
        cell.backgroundColor = .lightGray
        Skeleton.stopAnimaton(outlet: collectionView)
        return cell
    }
    //MARK: - Download Categories
    
    private func loadCategories() {
        downloadCategoriesFromFirebase { (allCategories) in
           
            self.categoryArray = allCategories
            self.collectionView.reloadData()
            
        }
    }

}


extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout { // collecitonView akış yapısı hücre boyutları belirleme fonksiyonları
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace // genişliğin ne olacağını bilmiyoruz o yüzden ekran ölçüsünden verdiğimiz paddingSpace'i çıkıyoruz
        let withPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: withPerItem, height: withPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension CategoryCollectionViewController { // Kategori celli seçildiğinde ilgili detay liste sayfasına gönderecek.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: itemSegue, sender: categoryArray[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == itemSegue {
            
            let VC = segue.destination as! ItemsTableViewController
            VC.category = sender as! Category
        }
            
    }
}
