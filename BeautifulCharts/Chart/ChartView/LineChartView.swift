//
//  LineChartView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class LineChartView: UIView {
    private lazy var chartBaseView = makeView(ChartBaseView(lineWidth: 2))
    private weak var valuePopupView: ValuePopupView?
    private weak var valuePopupViewCenterConstraint: NSLayoutConstraint?
    
    private var yLabels: [UILabel] = []
    private var xLabels: [UILabel] = []
    
    private var lineShapeLayers: [CAShapeLayer] = []
    
    private weak var valuePopupLineShapeLayer: CAShapeLayer?
    
    var chartData: ChartData? {
        didSet {
            chartBaseView.chartData = chartData
        }
    }
    
    private var configuration = ChartBaseView.Configuration()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 270)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chartBaseView)
        chartBaseView.constraintsToEdges(of: self, insets: UIEdgeInsets(top: 16, left: 0, bottom: 20, right: 0)).activate()
        
        let yLabelsStackView: UIStackView = makeView()
        yLabelsStackView.axis = .vertical
        yLabelsStackView.distribution = .equalSpacing
        
        for _ in 0..<6 {
            let yLabel: UILabel = makeView()
            yLabel.font = .systemFont(ofSize: 12)
            yLabel.text = "0"
            
            yLabelsStackView.addArrangedSubview(yLabel)
            yLabels.append(yLabel)
        }
        
        yLabels.reverse()
        
        addSubview(yLabelsStackView)
        yLabelsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).activate()
        yLabelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).activate()
        yLabelsStackView.leftAnchor.constraint(equalTo: leftAnchor).activate()
        yLabelsStackView.widthAnchor.constraint(equalToConstant: 60).activate()
        
        let xLabelsStackView: UIStackView = makeView()
        xLabelsStackView.axis = .horizontal
        xLabelsStackView.distribution = .equalSpacing
        
        for _ in 0..<6 {
            let xLabel: UILabel = makeView()
            xLabel.font = .systemFont(ofSize: 12)
            
            xLabelsStackView.addArrangedSubview(xLabel)
            xLabels.append(xLabel)
        }
        
        addSubview(xLabelsStackView)
        xLabelsStackView.rightAnchor.constraint(equalTo: rightAnchor).activate()
        xLabelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        xLabelsStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).activate()
        xLabelsStackView.heightAnchor.constraint(equalToConstant: 20).activate()
        
        for _ in 0..<6 {
            let lineShapeLayer = CAShapeLayer()
            lineShapeLayer.lineWidth = 1 / UIScreen.main.scale
            
            layer.insertSublayer(lineShapeLayer, below: chartBaseView.layer)
            lineShapeLayers.append(lineShapeLayer)
        }
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        longPressGestureRecognizer.allowableMovement = .infinity
        longPressGestureRecognizer.minimumPressDuration = 0
        longPressGestureRecognizer.delegate = self
        addGestureRecognizer(longPressGestureRecognizer)
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineShapeLayers.enumerated().forEach { index, shapeLayer in
            let path = UIBezierPath()
            let y = (bounds.height) / 6 * CGFloat(index) + 25
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: bounds.width, y: y))
            
            shapeLayer.path = path.cgPath
        }
        
        updateLabels()
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        yLabels.forEach {
            $0.textColor = newAppearance == .light ? #colorLiteral(red: 0.6766796708, green: 0.6954160333, blue: 0.7095927596, alpha: 1) : #colorLiteral(red: 0.3289504647, green: 0.3913390636, blue: 0.4559021592, alpha: 1)
        }
        
        xLabels.forEach {
            $0.textColor = newAppearance == .light ? #colorLiteral(red: 0.6766796708, green: 0.6954160333, blue: 0.7095927596, alpha: 1) : #colorLiteral(red: 0.3289504647, green: 0.3913390636, blue: 0.4559021592, alpha: 1)
        }
        
        lineShapeLayers.forEach {
            $0.strokeColor = newAppearance == .light ? #colorLiteral(red: 0.9074757695, green: 0.9116097093, blue: 0.9110304713, alpha: 1).cgColor : #colorLiteral(red: 0.09807170182, green: 0.138446182, blue: 0.1819486022, alpha: 1).cgColor
        }
        
        valuePopupLineShapeLayer?.strokeColor = newAppearance == .light ? #colorLiteral(red: 0.9074757695, green: 0.9116097093, blue: 0.9110304713, alpha: 1).cgColor : #colorLiteral(red: 0.09807170182, green: 0.138446182, blue: 0.1819486022, alpha: 1).cgColor
    }
    
    func setConfiguration(_ configuration: ChartBaseView.Configuration, animated: Bool) {
        self.configuration = configuration
        
        chartBaseView.setConfiguration(configuration, animated: animated)
        
        updateLabels()
    }
    
    private func updateLabels() {
        let (startTimeInverval, endTimeInterval) = chartBaseView.timeIntervals()
        let difference = endTimeInterval - startTimeInverval
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        xLabels.enumerated().forEach { index, xLabel in
            let date = Date(timeIntervalSince1970: startTimeInverval + difference / 6 * Double(index))
            
            xLabel.text = dateFormatter.string(from: date)
        }
        
        let largestYValue = chartBaseView.largestYValue(pointsOffset: 25)
        
        yLabels.enumerated().forEach { index, yLabel in
            let value = largestYValue / 6 * Double(index)
            
            if value.isFinite {
                yLabel.text = String(Int(value))
            }
        }
    }
    
    @objc private func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let chartData = chartData else {
            return
        }
        
        let xLocation = gestureRecognizer.location(in: self).x
        
        switch gestureRecognizer.state {
        case .began, .changed:
            let valuePopupView: ValuePopupView
            let valuePopupViewCenterConstraint: NSLayoutConstraint
            let valuePopupLineShapeLayer: CAShapeLayer
            
            if let view = self.valuePopupView,
                let constraint = self.valuePopupViewCenterConstraint,
                let shapeLayer = self.valuePopupLineShapeLayer {
                valuePopupView = view
                valuePopupViewCenterConstraint = constraint
                valuePopupLineShapeLayer = shapeLayer
            } else {
                let colors = chartData.columns.filter { !configuration.avoidRenderingLines.contains($0.name) } .map { $0.color }
                
                let view = makeView(ValuePopupView(valueColors: colors))
                self.valuePopupView = view
                valuePopupView = view
                
                addSubview(valuePopupView)
                valuePopupView.topAnchor.constraint(equalTo: topAnchor, constant: 10).activate()
                valuePopupViewCenterConstraint = valuePopupView.centerXAnchor.constraint(equalTo: leftAnchor, constant: xLocation).activated()
                self.valuePopupViewCenterConstraint = valuePopupViewCenterConstraint
                
                valuePopupLineShapeLayer = CAShapeLayer()
                self.valuePopupLineShapeLayer = valuePopupLineShapeLayer
                
                valuePopupLineShapeLayer.lineWidth = 1 / UIScreen.main.scale
                valuePopupLineShapeLayer.strokeColor = Theme.global.appearance == .light ? #colorLiteral(red: 0.9074757695, green: 0.9116097093, blue: 0.9110304713, alpha: 1).cgColor : #colorLiteral(red: 0.09807170182, green: 0.138446182, blue: 0.1819486022, alpha: 1).cgColor
                
                layer.insertSublayer(valuePopupLineShapeLayer, below: chartBaseView.layer)
            }
            
            valuePopupViewCenterConstraint.constant = xLocation
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xLocation, y: 20))
            path.addLine(to: CGPoint(x: xLocation, y: bounds.height - 20))
            
            valuePopupLineShapeLayer.path = path.cgPath
            
            let chartBaseViewXLocation = convert(CGPoint(x: xLocation, y: 0), to: chartBaseView).x
            let values = chartBaseView.valuesAt(x: chartBaseViewXLocation)
            
            valuePopupView.values = values
            
            let (startTimeInterval, endTimeInterval) = chartBaseView.timeIntervals()
            let difference = endTimeInterval - startTimeInterval
            
            let selectedTimeInterval = startTimeInterval + difference * Double(chartBaseViewXLocation / chartBaseView.bounds.width)
            
            let date = Date(timeIntervalSince1970: selectedTimeInterval)
            
            valuePopupView.date = date
        case .ended, .cancelled:
            valuePopupView?.removeFromSuperview()
            valuePopupLineShapeLayer?.removeFromSuperlayer()
        default:
            break
        }
    }
}

extension LineChartView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
