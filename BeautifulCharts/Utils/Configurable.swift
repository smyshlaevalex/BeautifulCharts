//
//  Configurable.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

protocol Configurable {
    associatedtype Item
    
    func configure(with item: Item)
}
