//
//  ValuePopupView.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/23/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class ValuePopupView: UIView {
    private lazy var dateLabel: AppearanceLabel = makeView() {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.text = "Dec 15"
    }
    
    private lazy var yearLabel: AppearanceLabel = makeView() {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "2019"
        $0.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
    }
    
    private var valueLabels: [UILabel] = []
    
    var date: Date = Date() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "YYYY"
            
            dateLabel.text = dateFormatter.string(from: date)
            yearLabel.text = yearFormatter.string(from: date)
        }
    }
    
    var values: [Double] = [] {
        didSet {
            zip(valueLabels, values).forEach { $0.0.text = String(Int($0.1)) }
        }
    }
    
    init(valueColors: [UIColor]) {
        super.init(frame: .zero)
        
        layer.masksToBounds = true
        layer.cornerRadius = 4
        
        let stackView: UIStackView = makeView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        addSubview(stackView)
        stackView.constraintsToEdges(of: self, insets: UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)).activate()
        
        let dateYearStackView: UIStackView = makeView()
        dateYearStackView.axis = .vertical
        
        stackView.addArrangedSubview(dateYearStackView)
        
        dateYearStackView.addArrangedSubview(dateLabel)
        dateYearStackView.addArrangedSubview(yearLabel)
        
        let valuesStackView: UIStackView = makeView()
        valuesStackView.axis = .vertical
        
        stackView.addArrangedSubview(valuesStackView)
        
        valueLabels = valueColors.map { color in
            let label: UILabel = makeView()
            label.textColor = color
            label.font = .systemFont(ofSize: 14)
            label.text = "0"
            
            valuesStackView.addArrangedSubview(label)
            
            return label
        }
        
        isThemingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func appearanceDidChange(_ newAppearance: Theme.Appearance) {
        backgroundColor = newAppearance == .light ? #colorLiteral(red: 0.9691597819, green: 0.966414988, blue: 0.9862328172, alpha: 1) : #colorLiteral(red: 0.103320457, green: 0.157954067, blue: 0.2145238817, alpha: 1)
    }
}
