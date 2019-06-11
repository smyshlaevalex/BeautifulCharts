//
//  ChartsViewController.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class ChartsViewController: AppearanceViewController {
    private lazy var tableView = makeView(AppearanceTableView(frame: .zero, style: .grouped)) {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 446
        $0.dataSource = self
        $0.delegate = self
        $0.register(cell: AppearanceTableViewCell.self)
    }
    
    private lazy var chartsData: [ChartData] = {
        guard let urlForChartData = Bundle.main.url(forResource: "chart_data", withExtension: "json"),
            let data = try? Data(contentsOf: urlForChartData) else {
                fatalError("Failed to read chart_data.json")
        }
        
        do {
            return try JSONDecoder().decode([ChartData].self, from: data)
        } catch {
            fatalError("Failed to decode ChartData, error: \(error)")
        }
    }()
    
    private lazy var chartCells = [ChartTableViewCell?](repeating: nil, count: chartsData.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Charts"
        
        view.addSubview(tableView)
        tableView.constraintsToEdges(of: view).activate()
    }
}

extension ChartsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int
        
        if section == 0 {
            rows = chartsData.count
        } else {
            rows = 1
        }
        
        return rows
    }
    
    // Cell reuse is disabled for performance reasons
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            let chartData = chartsData[indexPath.row]
            
            if let chartCell = chartCells[indexPath.row] {
                chartCell.configure(with: chartData)
                cell = chartCell
                
            } else {
                let chartCell = ChartTableViewCell(style: .default, reuseIdentifier: nil)
                chartCell.configure(with: chartData)
                chartCells[indexPath.row] = chartCell
                cell = chartCell
            }
        } else {
            let themeCell = tableView.dequeue(cell: AppearanceTableViewCell.self, for: indexPath)
            
            themeCell.textLabel?.textAlignment = .center
            themeCell.textLabel?.text = "Switch to Light Mode"
            
            cell = themeCell
        }
        
        return cell
    }
}

extension ChartsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = "Switch to \(Theme.global.appearance == .light ? "Light Mode" : "Dark Mod")"
            
            Theme.global.appearance = Theme.global.appearance == .light ? .dark : .light
        }
    }
}
