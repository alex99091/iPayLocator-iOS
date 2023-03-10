//
//  HomeViewController.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet weak var chargeButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var subTitleStackView: UIStackView!
    
    // MARK: - Property
    let bannerData = BannerData()
    let iconData = IconData()
    let hexColor = "#D7DFB8"
    let hexColorBG = "#F4ECF0"
    let customFont = "SingleDay-Regular"
    var timer: Timer?
    var currentIndex = 0

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        registerCollectionViewFeatures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    // MARK: - Method
    func configureStyle() {
        chargeButton.titleLabel?.font = UIFont(name: customFont, size: 15)
        chargeButton.layer.cornerRadius = 12.5
        chargeButton.layer.borderWidth = 5
        chargeButton.layer.borderColor = UIColor(hex: hexColor).cgColor
        chargeButton.backgroundColor = UIColor(hex: hexColorBG)
        
        giftButton.titleLabel?.font = UIFont(name: customFont, size: 15)
        giftButton.layer.cornerRadius = 12.5
        giftButton.layer.borderWidth = 5
        giftButton.layer.borderColor = UIColor(hex: hexColor).cgColor
        giftButton.backgroundColor = UIColor(hex: hexColorBG)
        
        subTitleStackView.layer.cornerRadius = 10
        homeCollectionView.layer.cornerRadius = 40 // 코너 라운드 처리
    }
    
    func registerCollectionViewFeatures() {
        homeCollectionView.register(BannerCell.uinib, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        homeCollectionView.register(CardCell.uinib, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
        homeCollectionView.register(IconCell.uinib, forCellWithReuseIdentifier: IconCell.reuseIdentifier)
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.collectionViewLayout = configureLayout()
    }
    
    func configureLayout() -> UICollectionViewLayout {
        // 컴포지셔널 레이아웃 생성
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                // 배너셀
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(0.75))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.75))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            } else if sectionIndex == 1 {
                // 카드셀
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 60, bottom: 10, trailing: 60)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(1.0))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                section.orthogonalScrollingBehavior = .paging
                
                return section
            } else {
                // 아이콘 셀
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(30),
                                                      heightDimension: .absolute(40))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(40))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(40)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.interItemSpacing = groupSpacing
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20)
                
                return section
            }
        }
        return layout
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let numberOfItems = self.homeCollectionView.numberOfItems(inSection: 0)
            if numberOfItems > 0 {
                let nextIndex = (self.currentIndex + 1) % numberOfItems
                let nextIndexPath = IndexPath(item: nextIndex, section: 0)
                self.homeCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                self.currentIndex = nextIndex
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return bannerData.imagePath.count
        case 1: return 1
        case 2: return iconData.imageLabel.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell
            let imagePath = bannerData.imagePath[indexPath.item]
            let scaledImage = UIImage(named: imagePath)?.scaled(toHeight: homeCollectionView.frame.width - 50)
            cell.bannerImage.image = scaledImage
            cell.bannerImage.contentMode = .scaleToFill
            cell.bannerImage.clipsToBounds = true
            cell.bannerImage.layer.cornerRadius = 25
            cell.bannerImage.alpha = 0.85
            
            return cell
            
        case 1:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath) as! CardCell
            return cell
            
        case 2:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: IconCell.reuseIdentifier, for: indexPath) as! IconCell
            let imagePath = iconData.imagePath[indexPath.item]
            let labelText = iconData.imageLabel[indexPath.item]
            cell.configureImage(with: imagePath)
            cell.configureText(with: labelText)
            return cell
            
        default: return UICollectionViewCell()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}
