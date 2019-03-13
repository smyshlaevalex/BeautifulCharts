//
//  UITableView+Register.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

extension UITableView {
    /**
     Register cell, will register nib if it exist,
     registering UITableViewCell is ok as long as only one is being registered
     */
    func register<Cell: UITableViewCell>(cell cellType: Cell.Type) {
        let cellName = String(describing: cellType)
        
        if Bundle.main.url(forResource: cellName, withExtension: "nib") != nil {
            let nib = UINib(nibName: cellName, bundle: nil)
            register(nib, forCellReuseIdentifier: cellName)
        } else {
            register(cellType, forCellReuseIdentifier: cellName)
        }
    }
    
    func register<Header: UITableViewHeaderFooterView>(header headerType: Header.Type) {
        let headerName = String(describing: headerType)
        
        if Bundle.main.url(forResource: headerName, withExtension: "nib") != nil {
            let nib = UINib(nibName: headerName, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: headerName)
        } else {
            register(headerType, forHeaderFooterViewReuseIdentifier: headerName)
        }
    }
    
    func dequeue<Cell: UITableViewCell>(cell cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        let cellName = String(describing: cellType)
        
        guard let cell = dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? Cell else {
            fatalError("Couldn't cast cell to \(cellName)")
        }
        
        return cell
    }
    
    func dequeue<Header: UITableViewHeaderFooterView>(header headerType: Header.Type) -> Header {
        let headerName = String(describing: headerType)
        
        let header: Header
        
        if let dequeuedHeader = dequeueReusableHeaderFooterView(withIdentifier: headerName) as? Header {
            header = dequeuedHeader
        } else {
            header = Header(reuseIdentifier: headerName)
        }
        
        return header
    }
}
