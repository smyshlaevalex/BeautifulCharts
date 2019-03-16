//
//  UIView+Edges.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol ViewConstraintInset {
    var insets: UIEdgeInsets { get }
}

extension UIEdgeInsets: ViewConstraintInset {
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: -bottom, right: -right)
    }
}

extension CGFloat: ViewConstraintInset {
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: self, left: self, bottom: -self, right: -self)
    }
}

extension Int: ViewConstraintInset {
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(self), left: CGFloat(self), bottom: CGFloat(-self), right: CGFloat(-self))
    }
}

extension UIView {
    func constraintsToEdges(of view: UIView, insets: ViewConstraintInset = 0, useMargins: Bool = false) -> [NSLayoutConstraint] {
        let topAnchor: NSLayoutYAxisAnchor
        let rightAnchor: NSLayoutXAxisAnchor
        let bottomAnchor: NSLayoutYAxisAnchor
        let leftAnchor: NSLayoutXAxisAnchor
        
        if useMargins {
            topAnchor = view.layoutMarginsGuide.topAnchor
            rightAnchor = view.layoutMarginsGuide.rightAnchor
            bottomAnchor = view.layoutMarginsGuide.bottomAnchor
            leftAnchor = view.layoutMarginsGuide.leftAnchor
        } else {
            topAnchor = view.topAnchor
            rightAnchor = view.rightAnchor
            bottomAnchor = view.bottomAnchor
            leftAnchor = view.leftAnchor
        }
        
        return [
            self.topAnchor.constraint(equalTo: topAnchor, constant: insets.insets.top),
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.insets.right),
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.insets.bottom),
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.insets.left)
        ]
    }
}
