//
//  BannerData.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import Foundation

struct BannerData: Codable {
    static let shared = BannerData()
    
    let imagePath: [String]
    
    init(imagePath: [String] = ["bannerImage1", "bannerImage2", "bannerImage3"]) {
        self.imagePath = imagePath
    }
}
