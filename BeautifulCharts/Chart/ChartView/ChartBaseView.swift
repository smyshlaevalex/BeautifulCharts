//
//  ChartBaseView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/14/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class ChartBaseView: UIView {
    struct Configuration {
        var range: ClosedRange<Double>
        var avoidRenderingLines: Set<String>
        
        init(range: ClosedRange<Double> = 0...1, avoidRenderingLines: Set<String> = []) {
            self.range = range
            self.avoidRenderingLines = avoidRenderingLines
        }
    }
    
    private var lineShapeLayers: [CAShapeLayer] = []
    
    private let lineWidth: CGFloat
    
    var chartData: ChartData? {
        didSet {
            setupChart()
        }
    }
    
    private var configuration = Configuration()
    
    private var oldSize: CGSize = .zero
    
    init(lineWidth: CGFloat) {
        self.lineWidth = lineWidth
        
        super.init(frame: .zero)
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if oldSize != bounds.size {
            lineShapeLayers.forEach {
                $0.frame = bounds
            }
            
            updateUI(animated: false)
            
            oldSize = bounds.size
        }
    }
    
    func setConfiguration(_ configuration: Configuration, animated: Bool) {
        self.configuration = configuration
        
        updateUI(animated: animated)
    }
    
    func timeIntervals() -> (start: TimeInterval, end: TimeInterval) {
        guard let chartData = chartData else {
            fatalError("ChartData is nil")
        }
        
        let xValues = chartData.xValues
        
        let range = configuration.range
        let firstValue = xValues[Int(Double(xValues.count - 1) * range.lowerBound)]
        let lastValue = xValues[Int(Double(xValues.count - 1) * range.upperBound)]
        
        return (start: firstValue / 1000, end: lastValue / 1000)
    }
    
    func largestYValue(pointsOffset: CGFloat) -> Double {
        guard let chartData = chartData else {
            fatalError("ChartData is nil")
        }
        
        let xValues = chartData.xValues
        
        let range = configuration.range
        let xValuesFirstIndex = Int(Double(xValues.count - 1) * range.lowerBound)
        let xValuesLastIndex = Int(Double(xValues.count - 1) * range.upperBound)
        
        let usedColumns = chartData.columns.filter { !configuration.avoidRenderingLines.contains($0.name) }
        
        let largestValue = usedColumns.flatMap { $0.values[xValuesFirstIndex...xValuesLastIndex] } .max() ?? 0
        
        let height = bounds.size.height
        let allowedHeight = height - pointsOffset
        
        return largestValue / Double(height) * Double(allowedHeight)
    }
    
    func valuesAt(x: CGFloat) -> [Double] {
        guard let chartData = chartData else {
            fatalError("ChartData is nil")
        }
        
        let xValues = chartData.xValues
        
        let range = configuration.range
        let xValuesFirstIndex = Int(Double(xValues.count - 1) * range.lowerBound)
        let xValuesLastIndex = Int(Double(xValues.count - 1) * range.upperBound)
        
        var values: [Double] = []
        
        for column in chartData.columns {
            let yValues = [Double](column.values[xValuesFirstIndex...xValuesLastIndex])
            
            let xFraction = x / bounds.width
            let firstIndex = Int(floor(CGFloat(yValues.count) * xFraction))
            let secondIndex = Int(ceil(CGFloat(yValues.count) * xFraction))
            let indexFraction = (CGFloat(yValues.count) * xFraction) - floor(CGFloat(yValues.count) * xFraction)
            
            guard firstIndex > 0 && firstIndex < yValues.count &&
                secondIndex > 0 && secondIndex < yValues.count else {
                return []
            }
            
            let firstValue = yValues[firstIndex]
            let secondValue = yValues[secondIndex]
            
            let value = (secondValue - firstValue) * Double(indexFraction) + firstValue
            
            values.append(value)
        }
        
        return values
    }
    
    private func setupChart() {
        guard let chartData = chartData else {
            return
        }
        
        lineShapeLayers.forEach { $0.removeFromSuperlayer() }
        lineShapeLayers = (0..<chartData.columns.count).map { _ in CAShapeLayer() }
        
        lineShapeLayers.forEach {
            layer.addSublayer($0)
            $0.fillColor = nil
            $0.lineWidth = lineWidth
        }
        
        updateUI(animated: false)
    }
    
    private func updateUI(animated: Bool) {
        guard let chartData = chartData else {
            return
        }
        
        let xValues = chartData.xValues
        
        let range = configuration.range
        let xValuesFirstIndex = Int(Double(xValues.count - 1) * range.lowerBound)
        let xValuesLastIndex = Int(Double(xValues.count - 1) * range.upperBound)
        let xValuesInRange = Array(xValues[xValuesFirstIndex...xValuesLastIndex])
        
        let usedColumns = chartData.columns.filter { !configuration.avoidRenderingLines.contains($0.name) }
                let size = bounds.size
        
        let allValues = usedColumns.flatMap { $0.values[xValuesFirstIndex...xValuesLastIndex] }
        
        for (column, lineShapeLayer) in zip(chartData.columns, lineShapeLayers) {
            let values = column.values[xValuesFirstIndex...xValuesLastIndex]
            
            let points = zip(xValuesInRange, values).map { x, y -> CGPoint in
                let xValueFraction = fraction(of: x, from: xValuesInRange.first!, to: xValuesInRange.last!)
                let yValueFraction = fraction(of: y, in: allValues)
                
                return CGPoint(x: xValueFraction * size.width, y: size.height - yValueFraction * size.height)
            }
            
            lineShapeLayer.strokeColor = column.color.cgColor
            
            let bezierPath = UIBezierPath()
            bezierPath.lineWidth = 2
            bezierPath.lineJoinStyle = .round
            
            bezierPath.move(to: points[0])
            
            for point in points.dropFirst() {
                bezierPath.addLine(to: point)
            }
            
            if animated {
                let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
                opacityAnimation.duration = 0.2
                opacityAnimation.fromValue = lineShapeLayer.opacity
                opacityAnimation.toValue = usedColumns.contains(column) ? 1 : 0
                lineShapeLayer.opacity = usedColumns.contains(column) ? 1 : 0
                lineShapeLayer.add(opacityAnimation, forKey: opacityAnimation.keyPath)
                
                let pathAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
                pathAnimation.duration = 0.2
                pathAnimation.fromValue = lineShapeLayer.path
                pathAnimation.toValue = bezierPath.cgPath
                lineShapeLayer.path = bezierPath.cgPath
                lineShapeLayer.add(pathAnimation, forKey: pathAnimation.keyPath)
            } else {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                lineShapeLayer.opacity = usedColumns.contains(column) ? 1 : 0
                lineShapeLayer.path = bezierPath.cgPath
                CATransaction.commit()
            }
        }
    }
    
    private func fraction(of timeInterval: TimeInterval, from fromValue: TimeInterval, to toValue: TimeInterval) -> CGFloat {
        let length = toValue - fromValue
        
        return CGFloat((timeInterval - fromValue) / length)
    }
    
    private func fraction<T: Sequence>(of value: Double, in array: T) -> CGFloat where T.Element == Double {
        guard let maxValue = array.max() else {
            return 0
        }
        
        return CGFloat(value / maxValue)
    }
}
