//
//  CardCell.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class CardCell: UICollectionViewCell, ReuseIdentifiable {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var chargeTitle: UILabel!
    @IBOutlet weak var chargeValue: UILabel!
    @IBOutlet weak var recentPayment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
    }
    
    func configureStyle() {
        cardImage.layer.cornerRadius = 25
        userId.text = "iPayLocator-01"
        chargeValue.text = "129,000원 입니다."
    }
    
}
