//
//  BasketItemsTableViewCell.swift
//  BuyMe!
//
//  Created by obss on 17.10.2022.
//

import UIKit

class BasketItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var pieceItem: UILabel!
    
    var piece: Int = 0
    
    func configure(item: Items, dict: [String : Int]){
        itemPrice.adjustsFontSizeToFitWidth = true
        itemName.text = item.name
        itemDescription.text = item.description
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            itemImage.isSkeletonable = true
            itemImage.startSkeletonAnimation()
            downloadImagesFromFirestore(imageUrls: [item.imageLinks.first!]) { images in
                self.itemImage.image = images.first as? UIImage ?? UIImage(named: "imagePlaceholder")
            }
            self.itemImage.stopSkeletonAnimation()
        }
        pieceEditor(itemID: item.id, dict: dict)
        itemPrice.text = Helper.currencyConverter(value: Double(self.piece) * item.price)
    }
    
    func defaultCell() {
        itemName.text = itemNotFound
        itemDescription.text = itemUploadAdvice
    }
    
    func pieceEditor(itemID: String, dict: [String : Int]){
        for (itemIDD, piece) in dict {
            if itemIDD == itemID {
                pieceItem.text = String(describing: piece)
                self.piece = piece
            }
        }
    }

}
