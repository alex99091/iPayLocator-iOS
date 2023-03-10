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
    @IBOutlet weak var subUIView: UIView!
    
    // MARK: - Property
    let buttonLogos: [String] = ["logo1", "logo2", "logo3"]
    var locationManger = CLLocationManager()
    var naverMapView = NMFMapView()
    var markers = [NMFMarker]()
    var cellDataList = [[String:String]]()
    var currentCoordinate: [String:Double] = ["lat":0.0, "lng":0.0]
    var currentName = ""
    
    // MARK: - MEthod
    override func viewDidLoad() {
        super.viewDidLoad()
        resultCollectionView.register(MapCell.uinib, forCellWithReuseIdentifier: MapCell.reuseIdentifier)
        resultCollectionView.dataSource = self
        resultCollectionView.delegate = self
        resultCollectionView.collectionViewLayout = configureLayout()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        configureMapView()
        configureButtonStyle()
        getLocationisAbled()
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
    
    func configureMapView() {
        // let naverMapView = NMFMapView(frame: view.frame)
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
        print("activated")
        
        subUIView.addSubview(naverMapView)
        subUIView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: subUIView.topAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: subUIView.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: subUIView.trailingAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: subUIView.bottomAnchor)
        ])
    }
    
    func getLocationisAbled() {
        if CLLocationManager.locationServicesEnabled() {
            print("????????? ON")
            locationManger.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.locationManger.stopUpdatingLocation()
            })
        } else {
            print("????????? Off")
        }
    }
    
    func configureLayout() -> UICollectionViewLayout {
        // ??????????????? ???????????? ??????
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // ?????? - ??? ???
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5 // ????????? ?????????
            
            return section
        }
        return layout
    }
    
    func configureLocationWithButton(_ keyword: String) {
        SearchAPI.searchWithKeyword(keyword: keyword, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchData):
                    guard let items = searchData.items else { return }
                    self.cellDataList = [[String:String]]()
                    for item in items {
                        var temp = ["type":"","title":"","address":"", "distance":"", "x": "", "y": ""]
                        if let itemTitle = item.title {
                            if itemTitle.contains("CU") {
                                temp.updateValue("cu", forKey: "type")
                            } else if itemTitle.contains("GS") {
                                temp.updateValue("gs", forKey: "type")
                            } else {
                                temp.updateValue("se", forKey: "type")
                            }
                            temp.updateValue(itemTitle, forKey: "title")
                        }
                        if let itemAddress = item.address {
                            temp.updateValue(itemAddress, forKey: "address")
                        }
                        if let x = Double(item.mapx!),
                           let y = Double(item.mapy!) {
                            let convertKATECH = NMGTm128.init(x: x, y: y)
                            let convertedLatLng = convertKATECH.toLatLng()
                            
                            let dataPoint = NMGPoint.init(x: convertedLatLng.lat, y: convertedLatLng.lng)
                            let currentPoint = NMGPoint.init(x: self.currentCoordinate["lat"]!, y: self.currentCoordinate["lng"]!)
                            let distance = dataPoint.distance(to: currentPoint) * 100000
                            
                            temp.updateValue(String(Int(distance)), forKey: "distance")
                            temp.updateValue(String(x), forKey: "x")
                            temp.updateValue(String(y), forKey: "y")
                        }
                        self.cellDataList.append(temp)
                    }
                    self.cellDataList.sort { Int($0["distance"]!)! < Int($1["distance"]!)! }
                    print("----------------")
                    print(self.cellDataList)
                    print("----------------")
                    self.resultCollectionView.reloadData()
                case .failure(let error):
                    print("failure: \(error)")
                }
            }
        })
    }
    
    func fetchReverseGeocode(_ lat: Double, _ lng: Double) {
        SearchAPI.fetchReverseGeocode(lat: lat, lng: lng, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let geocodeData):
                    guard let results = geocodeData.results else { return }
                    guard let region = results[0].region else { return }
                    guard let area3 = region.area3 else { return }
                    guard let name = area3.name else { return }
                    self.currentName = name
                case .failure(let error):
                    print("failure: \(error)")
                }
            }
        })
    }
    
    func createMarkers() {
        for data in cellDataList {
            if let x = Double(data["x"]!),
               let y = Double(data["y"]!) {
                let convertKATECH = NMGTm128.init(x: x, y: y)
                let convertedLatLng = convertKATECH.toLatLng()
                
                let marker = NMFMarker.init(position: convertedLatLng)
                if let image = UIImage(named: "marker") {
                    let size = CGSize(width: 24, height: 24)
                    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                    image.draw(in: CGRect(origin: .zero, size: size))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    let NMFImage = NMFOverlayImage(image: resizedImage!)
                    marker.iconImage = NMFImage
                }
                markers.append(marker)
            }
        }
        for marker in markers {
            marker.mapView = naverMapView
        }
    }
    
    func removeAllMarkers() {
        for marker in markers {
            marker.mapView = nil
        }
        markers = []
    }
    
    // MARK: - IB Actions
    @IBAction func cuButtonTapped(_ sender: Any) {
        configureLocationWithButton("\(currentName) ??????")
        removeAllMarkers()
        createMarkers()
        reloadInputViews()
    }
    @IBAction func gsButtonTapped(_ sender: Any) {
        configureLocationWithButton("\(currentName) GS25")
        removeAllMarkers()
        createMarkers()
        reloadInputViews()
    }
    @IBAction func seButtonTapped(_ sender: Any) {
        configureLocationWithButton("\(currentName) ???????????????")
        removeAllMarkers()
        createMarkers()
        reloadInputViews()
    }
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseIdentifier, for: indexPath) as! MapCell
        let data = cellDataList[indexPath.item]
        if let inputImage = data["type"],
           let inputTitle = data["title"],
           let inputAddress = data["address"],
           let distance = data["distance"] {
            cell.configureImage(inputImage)
            cell.configureTitle(inputTitle)
            cell.configureAddress(inputAddress)
            cell.configureDistance("??????: " + distance + "m")
        }
        return cell
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // ?????? ????????????
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        
        // ?????? ????????? ??????
        guard let currentLat = location?.coordinate.latitude else { return }
        // ?????? ????????? ??????
        guard let currentLng = location?.coordinate.longitude else { return }
        
        // ?????? API ????????? ??????
        let cameraPosition = naverMapView.cameraPosition
        print("cameraPosition - \(cameraPosition)")
        
        // update ????????? ??????
        let updatePosition = NMGLatLng(lat: currentLat, lng: currentLng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: updatePosition, zoomTo: 14)
        naverMapView.moveCamera(cameraUpdate)
        
        // ?????? ?????? ??????
        naverMapView.mapType = .basic
        // ?????? ?????? ????????????
        naverMapView.positionMode = .normal
        // Geocode fetch?????? -> ?????? ????????? ?????? ?????? + ????????? ???????????? ?????? ??????
        fetchReverseGeocode(currentLat, currentLng)
        currentCoordinate.updateValue(currentLng, forKey: "lng")
        currentCoordinate.updateValue(currentLat, forKey: "lat")
    }
    
    // ?????? ?????? ???????????? ??????
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension MapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let x = cellDataList[indexPath.item]["x"],
           let y = cellDataList[indexPath.item]["y"] {
            if let DoubleX = Double(x),
               let DoubleY = Double(y) {
                let convertKATECH = NMGTm128.init(x: DoubleX, y: DoubleY)
                let convertedLatLng = convertKATECH.toLatLng()
                let updatePosition = NMGLatLng(lat: convertedLatLng.lat, lng: convertedLatLng.lng)
                let cameraUpdate = NMFCameraUpdate(scrollTo: updatePosition, zoomTo: 14)
                naverMapView.moveCamera(cameraUpdate)
                createMarkers()
            }
        }
    }
}
