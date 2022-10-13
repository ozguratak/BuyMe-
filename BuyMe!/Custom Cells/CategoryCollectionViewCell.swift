//
//  CategoryCollectionViewCell.swift
//  BuyMe!
//
//  Created by obss on 5.10.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var Label: UILabel!
    
    func generateCell(_ category: Category) {
        
        Label.text = category.name
        cellImage.image = category.image
        
    }
}
