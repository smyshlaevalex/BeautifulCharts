//
//  AppearanceViewController.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class AppearanceViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func loadView() {
        view = AppearanceView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isThemingEnabled = true
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        statusBarStyle = newAppearance == .light ? .default : .lightContent
    }
}
