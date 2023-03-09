//
//  IconCell.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class IconCell: UICollectionViewCell, ReuseIdentifiable {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureImage(with imageName: String) {
        iconImage.image = UIImage(systemName: imageName)
    }
    
    func configureText(with text: String) {
        iconLabel.text = text
    }
    
}
