//
//  SearchData.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/10.
//

import Foundation

// MARK: - SearchData
struct SearchData: Codable {
    let lastBuildDate: String?
    let total, start, display: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let title: String?
    let link: String?
    let category, description, telephone, address: String?
    let roadAddress, mapx, mapy: String?
}
