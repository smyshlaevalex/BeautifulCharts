//
//  MakeView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

func makeView<View: UIView>(_ view: View = View(), _ block: ((View) -> Void)? = nil) -> View {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    block?(view)
    
    return view
}
