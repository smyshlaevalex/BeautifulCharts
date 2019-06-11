//
//  AppearanceTableViewCell.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class AppearanceTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.backgroundColor = .clear
        
        let backgroundColorView = UIView()
        selectedBackgroundView = backgroundColorView
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        backgroundColor = .secondaryBackgroundColor(for: newAppearance)
        tintColor = .tintColor(for: newAppearance)
        selectedBackgroundView?.backgroundColor = newAppearance == .light ? #colorLiteral(red: 0.852, green: 0.849, blue: 0.852, alpha: 1) : #colorLiteral(red: 0.1024192298, green: 0.1477668307, blue: 0.1984970027, alpha: 1)
        textLabel?.textColor = .textColor(for: newAppearance)
    }
}
