//
//  NSLayoutConstraint+Activate.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func activate() {
        isActive = true
    }
    
    func deactivate() {
        isActive = false
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}
