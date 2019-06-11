//
//  ChartView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class ChartView: UIView {
    private lazy var stackView: UIStackView = makeView() {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
    }
    
    private lazy var lineChartView = makeView(LineChartView())
    private lazy var chartDateSliderView = makeView(ChartDateSliderView()) {
        $0.delegate = self
    }
    
    private lazy var lineSelectorView = makeView(LineSelectorView()) {
        $0.delegate = self
    }
    
    var chartData: ChartData? {
        didSet {
            if chartData != oldValue {
                lineChartView.chartData = chartData
                chartDateSliderView.chartData = chartData
                lineSelectorView.chartDataColumns = chartData?.columns ?? []
            }
        }
    }
    private var configuration = ChartBaseView.Configuration()
    
    private let chartOffset: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.constraintsToEdges(of: self).activate()
        
        stackView.addArrangedSubview(lineChartView)
        lineChartView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: chartOffset).activate()
        lineChartView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -chartOffset).activate()
        
        stackView.addArrangedSubview(chartDateSliderView)
        chartDateSliderView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: chartOffset).activate()
        chartDateSliderView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -chartOffset).activate()
        
        stackView.addArrangedSubview(lineSelectorView)
        lineSelectorView.leftAnchor.constraint(equalTo: stackView.leftAnchor).activate()
        lineSelectorView.rightAnchor.constraint(equalTo: stackView.rightAnchor).activate()
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        backgroundColor = .secondaryBackgroundColor(for: newAppearance)
    }
}

extension ChartView: ChartDateSliderViewDelegate {
    func chartDateSliderView(_ chartDateSliderView: ChartDateSliderView, didChangeRange range: ClosedRange<Double>) {
        configuration.range = range
        lineChartView.setConfiguration(configuration, animated: false)
    }
}

extension ChartView: LineSelectorViewDelegate {
    func didChangeRenderingLines(in lineSelectorView: LineSelectorView) {
        configuration.avoidRenderingLines = lineSelectorView.avoidRenderingLines
        lineChartView.setConfiguration(configuration, animated: true)
        chartDateSliderView.updateConfiguration(configuration)
    }
}
