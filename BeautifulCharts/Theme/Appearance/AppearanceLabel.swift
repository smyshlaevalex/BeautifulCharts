//
//  AppearanceLabel.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class AppearanceLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        textColor = .textColor(for: newAppearance)
    }
}
