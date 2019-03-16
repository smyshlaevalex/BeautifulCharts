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
    
    func activated() -> NSLayoutConstraint {
        isActive = true
        
        return self
    }
    
    func deactivated() -> NSLayoutConstraint {
        isActive = false
        
        return self
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
    func activated() -> [NSLayoutConstraint] {
        NSLayoutConstraint.activate(self)
        
        return self
    }
    
    func deactivated() -> [NSLayoutConstraint] {
        NSLayoutConstraint.deactivate(self)
        
        return self
    }
}
