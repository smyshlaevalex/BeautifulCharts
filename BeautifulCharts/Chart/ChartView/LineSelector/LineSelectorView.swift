//
//  LineSelectorView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol LineSelectorViewDelegate: class {
    func didChangeRenderingLines(in lineSelectorView: LineSelectorView)
}

class LineSelectorView: UIView {
    private lazy var tableView: AppearanceTableView = makeView {
        $0.isScrollEnabled = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(cell: AppearanceTableViewCell.self)
    }
    
    var chartDataColumns: [ChartData.Column] = [] {
        didSet {
            invalidateIntrinsicContentSize()
            avoidRenderingLines = []
            tableView.reloadData()
        }
    }
    
    var avoidRenderingLines: Set<String> = []
    
    weak var delegate: LineSelectorViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: CGFloat(chartDataColumns.count) * 44 - 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.constraintsToEdges(of: self).activate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LineSelectorView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartDataColumns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: AppearanceTableViewCell.self, for: indexPath)
        
        let column = chartDataColumns[indexPath.row]
        cell.imageView?.image = .roundedColorIcon(color: column.color, size: CGSize(width: 18, height: 18), radius: 4)
        cell.textLabel?.text = column.name
        cell.accessoryType = .checkmark
        
        return cell
    }
}

extension LineSelectorView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let name = chartDataColumns[indexPath.row].name
        
        if avoidRenderingLines.contains(name) {
            cell?.accessoryType = .checkmark
            avoidRenderingLines.remove(name)
        } else {
            cell?.accessoryType = .none
            avoidRenderingLines.update(with: name)
        }
        
        delegate?.didChangeRenderingLines(in: self)
    }
}
