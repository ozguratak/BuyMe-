//
//  TableViewCell.swift
//  BuyMe!
//
//  Created by obss on 6.10.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    //MARK: - IBOutlets
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Cell Configure
    
    func cellConfigure(_ item: Items) {
        
        
        itemPrice.text = Helper.currencyConverter(value: item.price)
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
    }
    
    func defaultCell(){
        
        itemName.text = itemNotFound
        itemDescription.text = itemUploadAdvice
        
    }
}


extension TableViewCell: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        <#code#>
    //    }
    //
}
