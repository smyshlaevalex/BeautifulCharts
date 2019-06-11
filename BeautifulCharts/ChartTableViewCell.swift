//
//  ChartTableViewCell.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/17/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class ChartTableViewCell: AppearanceTableViewCell, Configurable {
    private lazy var chartView: ChartView = makeView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(chartView)
        chartView.constraintsToEdges(of: contentView).activate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ChartData) {
        chartView.chartData = item
    }
}
