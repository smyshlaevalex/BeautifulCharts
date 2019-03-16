//
//  AppearanceTableView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class AppearanceTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        backgroundColor = .secondaryBackgroundColor(for: newAppearance)
        separatorColor = newAppearance == .light ? nil : #colorLiteral(red: 0.07146853954, green: 0.1031122729, blue: 0.1385119855, alpha: 1)
    }
}
