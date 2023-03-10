//
//  MapCell.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class MapCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IB Outlets
    @IBOutlet weak var marketImage: UIImageView!
    @IBOutlet weak var marketTitle: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Method
    func configureImage(_ input: String) {
        marketImage.image = UIImage(named: input)
        marketImage.contentMode = .scaleToFill
        marketImage.layer.cornerRadius = 10
    }
    func configureTitle(_ input: String) {
        let cleanedInput = input.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        marketTitle.text = cleanedInput
    }
    func configureAddress(_ input: String) {
        address.text = input
    }
    func configureDistance(_ input: String) {
        distance.text = input
    }
}
