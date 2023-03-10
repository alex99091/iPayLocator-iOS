//
//  Bundle.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import Foundation

extension Bundle {
    
    var NMFClientId: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["NMFClientId"] as? String else { return nil }
        
        return key
    }
    
    var NMFClientSecret: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["NMFClientSecret"] as? String else { return nil }
        
        return key
    }
    
    var SearchClientId: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["SearchClientId"] as? String else { return nil }
        
        return key
    }
    
    var SearchClientSecret: String? {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["SearchClientSecret"] as? String else { return nil }
        
        return key
    }
    
}
