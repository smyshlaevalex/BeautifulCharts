//
//  NSObject+Appearance.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension NSObject {
    private static var isThemingEnabledKey: UInt8 = 0
    private static var appearanceObserverKey: UInt8 = 1
    
    var isThemingEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, &NSObject.isThemingEnabledKey) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &NSObject.isThemingEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            
            if newValue {
                appearanceObserver = NotificationCenter.default.addObserver(forName: Theme.appearanceDidChange,
                                                                            object: nil,
                                                                            queue: .main) { [weak self] notification in
                    guard let appearance = notification.object as? Theme.Appearance else {
                        return
                    }
                    
                    self?.appearanceDidChange(appearance)
                }
                
                appearanceDidChange(Theme.global.appearance)
            } else {
                if let appearanceObserver = appearanceObserver {
                    NotificationCenter.default.removeObserver(appearanceObserver)
                }
            }
        }
    }
    
    private var appearanceObserver: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &NSObject.appearanceObserverKey) as? NSObjectProtocol
        }
        
        set {
            objc_setAssociatedObject(self, &NSObject.appearanceObserverKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @objc func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        
    }
}
