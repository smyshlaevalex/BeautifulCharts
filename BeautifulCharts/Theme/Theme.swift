//
//  Theme.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class Theme {
    @objc enum Appearance: Int {
        case light, dark
    }
    
    static let appearanceDidChange = Notification.Name(rawValue: "ThemeAppearanceDidChange")
    
    static let global = Theme()
    
    private init() {}
    
    var appearance: Appearance = .light {
        didSet {
            didSetAppearance()
        }
    }
    
    private func didSetAppearance() {
        NotificationCenter.default.post(name: Theme.appearanceDidChange, object: appearance)
    }
}
