//
//  NSLayoutConstraint+Priority.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        
        return self
    }
}

extension Array where Element == NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> [NSLayoutConstraint] {
        forEach { $0.priority = priority }
        
        return self
    }
}
