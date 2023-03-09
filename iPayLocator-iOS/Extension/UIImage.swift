//
//  UIImage.swift
//  iPayLocator-iOS
//
//  Created by BOONGKI KWAK on 2023/03/09.
//

import UIKit

extension UIImage {
    func scaled(toHeight newHeight: CGFloat) -> UIImage? {
        let imageSize = self.size
        let scaleFactor = newHeight / imageSize.height

        let newWidth = imageSize.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)

        let renderer = UIGraphicsImageRenderer(size: newSize)

        let scaledImage = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return scaledImage
    }
}
