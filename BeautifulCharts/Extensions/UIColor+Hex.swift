//
//  UIColor+Hex.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        guard hex.count == 7 else {
            return nil
        }
        
        let colorString = hex.dropFirst()
        
        let redString = colorString.prefix(2)
        
        let startIndex = colorString.index(colorString.startIndex, offsetBy: 2)
        let endIndex = colorString.index(startIndex, offsetBy: 1)
        let greenString = colorString[startIndex...endIndex]
        
        let blueString = colorString.suffix(2)
        
        guard let redInt = Int(redString, radix: 16),
            let greenInt = Int(greenString, radix: 16),
            let blueInt = Int(blueString, radix: 16) else {
            return nil
        }
        
        self.init(red: CGFloat(redInt) / 255,
                  green: CGFloat(greenInt) / 255,
                  blue: CGFloat(blueInt) / 255,
                  alpha: 1)
    }
    
    func hexString() -> String {
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        
        getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: nil)
        
        let redInt = Int(redComponent * 255)
        let greenInt = Int(greenComponent * 255)
        let blueInt = Int(blueComponent * 255)
        
        var hex = "#"
        
        hex.append(String(format: "%02x", redInt))
        hex.append(String(format: "%02x", greenInt))
        hex.append(String(format: "%02x", blueInt))
        
        return hex
    }
}
