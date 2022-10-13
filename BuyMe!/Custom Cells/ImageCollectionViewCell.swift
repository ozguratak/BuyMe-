//
//  CollectionViewCell.swift
//  BuyMe!
//
//  Created by obss on 11.10.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    
    func generateCell (itemImage: UIImage) {
        imageCell.image = itemImage
    }
}
