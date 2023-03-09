//
//  MapViewController.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit
import MapKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Property
    let buttonLogos: [String] = ["logo1", "logo2", "logo3"]
    var locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonStyle()
        resultCollectionView.dataSource = self
    }
    
    func configureButtonStyle() {
        for i in 0...2 {
            let logo = UIImage(named: buttonLogos[i])
            let logoImageView = UIImageView(image: logo)
            logoImageView.contentMode = .scaleToFill
            buttonCollection[i].addSubview(logoImageView)
            NSLayoutConstraint.activate([
                logoImageView.leadingAnchor.constraint(equalTo: buttonCollection[i].leadingAnchor),
                logoImageView.trailingAnchor.constraint(equalTo: buttonCollection[i].trailingAnchor),
                logoImageView.topAnchor.constraint(equalTo: buttonCollection[i].topAnchor),
                logoImageView.bottomAnchor.constraint(equalTo: buttonCollection[i].bottomAnchor)
            ])
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            buttonCollection[i].layer.borderColor = UIColor(hex: "#EBB3B8").cgColor
            buttonCollection[i].layer.borderWidth = 0.5
            buttonCollection[i].layer.cornerRadius = 15
        }
    }

}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

