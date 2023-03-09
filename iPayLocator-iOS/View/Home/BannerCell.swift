//
//  BannerCell.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class BannerCell: UICollectionViewCell, ReuseIdentifiable {
    
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureImage(with imagePath: String) {
        if let image = UIImage(named: imagePath) {
            bannerImage.image = image
            bannerImage.contentMode = .scaleToFill
        }
    }
    
}
