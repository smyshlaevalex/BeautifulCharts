//
//  UIImage+Icons.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/15/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension UIImage {
    enum ChevronDirection {
        case left, right
    }
    
    static func roundedColorIcon(color: UIColor, size: CGSize, radius: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            color.setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius).fill()
        }
    }
    
    static func shevronIcon(direction: ChevronDirection) -> UIImage {
        let size = CGSize(width: 3, height: 10)
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            UIColor.white.setStroke()
            
            let path = UIBezierPath()
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            
            path.move(to: CGPoint(x: size.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: size.height / 2))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            
            path.stroke()
        }
        
        let chevronImage: UIImage
        
        switch direction {
        case .left:
            chevronImage = image
        case .right:
            chevronImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
        }
        
        return chevronImage
    }
}
