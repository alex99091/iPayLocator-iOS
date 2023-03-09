//
//  HomeViewController.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var chargeButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var subTitleStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        homeCollectionView.register(BannerCell.uinib, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        homeCollectionView.register(CardCell.uinib, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
        homeCollectionView.register(IconCell.uinib, forCellWithReuseIdentifier: IconCell.reuseIdentifier)
        
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
    
    func style() {
        let hexColor = "#D7DFB8"
        let hexColorBG = "#F4ECF0"
        let customFont = "SingleDay-Regular"
        
        chargeButton.titleLabel?.font = UIFont(name: customFont, size: 16)
        chargeButton.layer.cornerRadius = 12.5
        chargeButton.layer.borderWidth = 5
        chargeButton.layer.borderColor = UIColor(hex: hexColor).cgColor
        chargeButton.backgroundColor = UIColor(hex: hexColorBG)

        giftButton.titleLabel?.font = UIFont(name: customFont, size: 16)
        giftButton.layer.cornerRadius = 12.5
        giftButton.layer.borderWidth = 5
        giftButton.layer.borderColor = UIColor(hex: hexColor).cgColor
        giftButton.backgroundColor = UIColor(hex: hexColorBG)
        
        subTitleStackView.layer.cornerRadius = 10
        homeCollectionView.layer.cornerRadius = 25 // 코너 라운드 처리
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 1
        case 2: return 4
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath)
            return cell
        case 1:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath)
            return cell
        case 2:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: IconCell.reuseIdentifier, for: indexPath)
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}
