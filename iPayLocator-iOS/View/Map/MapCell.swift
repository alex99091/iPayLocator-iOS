//
//  MapCell.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class MapCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - IB Outlets
    @IBOutlet weak var marketTitle: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
