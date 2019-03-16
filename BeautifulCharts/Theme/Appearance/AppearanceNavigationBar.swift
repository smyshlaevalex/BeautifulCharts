//
//  AppearanceNavigationBar.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class AppearanceNavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isTranslucent = false
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        barStyle = newAppearance == .light ? .default : .black
        barTintColor = .secondaryBackgroundColor(for: newAppearance)
        tintColor = .textColor(for: newAppearance)
    }
}
