//
//  ChartDateSliderView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/15/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol ChartDateSliderViewDelegate: class {
    func chartDateSliderView(_ chartDateSliderView: ChartDateSliderView, didChangeRange range: ClosedRange<Double>)
}

class ChartDateSliderView: UIView {
    private lazy var chartBaseView = makeView(ChartBaseView(lineWidth: 1))
    private lazy var thumbView: ChartDateSliderThumbView = makeView() {
        $0.delegate = self
    }
    
    private var thumbViewLeftConstraint: NSLayoutConstraint?
    private var thumbViewRightConstraint: NSLayoutConstraint?
    
    var chartData: ChartData? {
        didSet {
            chartBaseView.chartData = chartData
        }
    }
    
    weak var delegate: ChartDateSliderViewDelegate?
    
    private var oldSize: CGSize = .zero
    
    private let minimumThumbSize: CGFloat = 50
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 48)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chartBaseView)
        chartBaseView.constraintsToEdges(of: self, insets: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)).activate()
        
        addSubview(thumbView)
        thumbView.topAnchor.constraint(equalTo: topAnchor).activate()
        thumbView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        thumbViewLeftConstraint = thumbView.leftAnchor.constraint(equalTo: leftAnchor, constant: 100).activated()
        thumbViewRightConstraint = thumbView.rightAnchor.constraint(equalTo: leftAnchor, constant: 200).activated()
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if oldSize != bounds.size {
            if bounds.width > 0 && oldSize.width > 0 {
                let leftPullerFraction = thumbView.frame.minX / oldSize.width
                let rightPullerFraction = thumbView.frame.maxX / oldSize.width
                
                thumbViewLeftConstraint?.constant = leftPullerFraction * bounds.size.width
                thumbViewRightConstraint?.constant = rightPullerFraction * bounds.size.width
            }
            
            updateDelegate()
            
            oldSize = bounds.size
        }
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        chartBaseView.backgroundColor = newAppearance == .light ? #colorLiteral(red: 0.9657368064, green: 0.9732384086, blue: 0.9794408679, alpha: 1) : #colorLiteral(red: 0.1136006042, green: 0.1627588272, blue: 0.2282130122, alpha: 1)
    }
    
    func updateConfiguration(_ configuration: ChartBaseView.Configuration) {
        chartBaseView.setConfiguration(configuration, animated: true)
    }
    
    private func moveThumb(offset: CGFloat) {
        thumbViewLeftConstraint?.constant = min(max(thumbView.frame.minX + offset, 0), bounds.width - thumbView.bounds.width)
        thumbViewRightConstraint?.constant = min(max(thumbView.frame.maxX + offset, thumbView.bounds.width), bounds.width)
        
        updateDelegate()
    }
    
    private func extendThumb(direction: ChartDateSliderThumbView.ExtensionDirection, offset: CGFloat) {
        switch direction {
        case .left:
            thumbViewLeftConstraint?.constant = min(max(thumbView.frame.minX + offset, 0), thumbView.frame.maxX - minimumThumbSize)
        case .right:
            thumbViewRightConstraint?.constant = max(min(thumbView.frame.maxX + offset, bounds.width), thumbView.frame.minX + minimumThumbSize)
        }
        
        updateDelegate()
    }
    
    private func updateDelegate() {
        let leftPullerX = thumbViewLeftConstraint?.constant ?? 0
        let rightPullerX = thumbViewRightConstraint?.constant ?? 0
        
        delegate?.chartDateSliderView(self, didChangeRange: Double(leftPullerX / bounds.width)...Double(rightPullerX / bounds.width))
    }
}

extension ChartDateSliderView: ChartDateSliderThumbViewDelegate {
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView, didBeginMoving offset: CGFloat) {
        moveThumb(offset: offset)
    }
    
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView, didMove offset: CGFloat) {
        moveThumb(offset: offset)
    }
    
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView, didEndMoving offset: CGFloat) {
        moveThumb(offset: offset)
    }
    
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView,
                                  didBeginExtending direction: ChartDateSliderThumbView.ExtensionDirection,
                                  offset: CGFloat) {
        extendThumb(direction: direction, offset: offset)
    }
    
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView,
                                  didExtend direction: ChartDateSliderThumbView.ExtensionDirection,
                                  offset: CGFloat) {
        extendThumb(direction: direction, offset: offset)
    }
    
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView,
                                  didEndExtending direction: ChartDateSliderThumbView.ExtensionDirection,
                                  offset: CGFloat) {
        extendThumb(direction: direction, offset: offset)
    }
}
