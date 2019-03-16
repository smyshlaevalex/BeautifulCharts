//
//  UIColor+Appearance.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension UIColor {
    static func tintColor(for appearance: Theme.Appearance) -> UIColor {
        return appearance == .light ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0.5456670317, blue: 1, alpha: 1)
    }
    
    static func textColor(for appearance: Theme.Appearance) -> UIColor {
        return appearance == .light ? .black : .white
    }
    
    static func backgroundColor(for appearance: Theme.Appearance) -> UIColor {
        return appearance == .light ? #colorLiteral(red: 0.9384416938, green: 0.9356508851, blue: 0.9556260705, alpha: 1) : #colorLiteral(red: 0.09284769744, green: 0.1334874332, blue: 0.1772165895, alpha: 1)
    }
    
    static func tableViewHeaderColor(for appearance: Theme.Appearance) -> UIColor {
        return appearance == .light ? #colorLiteral(red: 0.43, green: 0.43, blue: 0.45, alpha: 1) : .white
    }
    
    static func secondaryBackgroundColor(for appearance: Theme.Appearance) -> UIColor {
        return appearance == .light ? #colorLiteral(red: 0.9691255689, green: 0.9698591828, blue: 0.9692392945, alpha: 1) : #colorLiteral(red: 0.1287393868, green: 0.1865426898, blue: 0.2507014871, alpha: 1)
    }
        
}
