//
//  ChartDateSliderThumbView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/15/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol ChartDateSliderThumbViewDelegate: class {
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView, didBeginMoving offset: CGFloat)
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView, didMove offset: CGFloat)
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView, didEndMoving offset: CGFloat)
    
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView,
                                  didBeginExtending direction: ChartDateSliderThumbView.ExtensionDirection,
                                  offset: CGFloat)
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView,
                                  didExtend direction: ChartDateSliderThumbView.ExtensionDirection,
                                  offset: CGFloat)
    func chartDateSliderThumbView(_ chartDateSliderThumbView: ChartDateSliderThumbView,
                                  didEndExtending direction: ChartDateSliderThumbView.ExtensionDirection,
                                  offset: CGFloat)
}

class ChartDateSliderThumbView: UIView {
    enum ExtensionDirection {
        case left, right
    }
    
    private enum State {
        case moving
        case extending(direction: ExtensionDirection)
    }
    
    private let shapeLayer = CAShapeLayer()
    
    private var state: State?
    private var xTranslation: CGFloat = 0
    
    private let pullerOffset: CGFloat = 10
    
    weak var delegate: ChartDateSliderThumbViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shapeLayer.strokeColor = nil
        shapeLayer.fillRule = .evenOdd
        layer.addSublayer(shapeLayer)
        
        let leftChevronImageView = makeView(UIImageView(image: .shevronIcon(direction: .left)))
        
        addSubview(leftChevronImageView)
        leftChevronImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).activate()
        leftChevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        let rightChevronImageView = makeView(UIImageView(image: .shevronIcon(direction: .right)))
        
        addSubview(rightChevronImageView)
        rightChevronImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).activate()
        rightChevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        longPressGestureRecognizer.allowableMovement = .infinity
        longPressGestureRecognizer.minimumPressDuration = 0
        addGestureRecognizer(longPressGestureRecognizer)
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = bounds
        
        let outerBezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
        let innerBezierPath = UIBezierPath(rect: bounds.insetBy(dx: pullerOffset, dy: 2))
        outerBezierPath.append(innerBezierPath)
        
        shapeLayer.path = outerBezierPath.cgPath
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        let shapeLayerColor = newAppearance == .light ? #colorLiteral(red: 0.7921360135, green: 0.8313952684, blue: 0.8695033193, alpha: 1) : #colorLiteral(red: 0.205478996, green: 0.2727015615, blue: 0.3499450386, alpha: 1)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shapeLayer.fillColor = shapeLayerColor.withAlphaComponent(0.9).cgColor
        CATransaction.commit()
    }
    
    @objc private func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let x = gestureRecognizer.location(in: self).x
            xTranslation = x
            
            if x <= pullerOffset {
                state = .extending(direction: .left)
            } else if x >= bounds.width - pullerOffset {
                state = .extending(direction: .right)
            } else {
                state = .moving
            }
        }
        
        let offset = gestureRecognizer.location(in: self).x - xTranslation
        
        switch state {
        case .moving?:
            switch gestureRecognizer.state {
            case .began:
                delegate?.chartDateSliderThumbView(self, didBeginMoving: offset)
            case .changed:
                delegate?.chartDateSliderThumbView(self, didMove: offset)
            case .ended, .cancelled:
                delegate?.chartDateSliderThumbView(self, didEndMoving: offset)
                state = nil
            default:
                break
            }
        case .extending(let direction)?:
            if direction == .right {
                xTranslation += offset
            }
            
            switch gestureRecognizer.state {
            case .began:
                delegate?.chartDateSliderThumbView(self, didBeginExtending: direction, offset: offset)
            case .changed:
                delegate?.chartDateSliderThumbView(self, didExtend: direction, offset: offset)
            case .ended, .cancelled:
                delegate?.chartDateSliderThumbView(self, didEndExtending: direction, offset: offset)
                state = nil
            default:
                break
            }
        case nil:
            break
        }
    }
}
