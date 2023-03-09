//
//  IconData.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import Foundation

struct IconData: Codable {
    static let shared = IconData()
    
    let imagePath: [String]
    let imageLabel: [String]
    
    init(imagePath: [String] = ["camera.macro","camera.aperture","dot.arrowtriangles.up.right.down.left.circle","gift"],
         imageLabel: [String] = ["핫이슈","기획전","혜택","이벤트"]) {
        self.imagePath = imagePath
        self.imageLabel = imageLabel
    }
}
