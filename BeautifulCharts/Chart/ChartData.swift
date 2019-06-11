//
//  ChartData.swift
//  BeautifulCharts
//
//  Created by Alexander on 3/13/19.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

struct ChartData: Equatable, Decodable {
    private enum ChartCodingKeys: String, CodingKey {
        case columns, types, colors, names
    }
    
    private enum ColumnType: String, Decodable {
        case line, x
    }
    
    struct Column: Equatable {
        let name: String
        let color: UIColor
        let values: [Double]
        
        static func == (lhs: Column, rhs: Column) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    let xValues: [TimeInterval]
    let columns: [Column]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChartCodingKeys.self)
        
        var columnsContainer = try container.nestedUnkeyedContainer(forKey: .columns)
        let typesContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .types)
        let colorsContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .colors)
        let namesContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .names)
        
        let identifiers = typesContainer.allKeys
        
        var xIdentifierWrapped: DynamicCodingKey?
        var lineIdentifiers: [DynamicCodingKey] = []
        
        for identifier in identifiers {
            let type = try typesContainer.decode(ColumnType.self, forKey: identifier)
            
            switch type {
            case .x:
                xIdentifierWrapped = identifier
            case .line:
                lineIdentifiers.append(identifier)
            }
        }
        
        guard let xIdentifier = xIdentifierWrapped else {
            throw DecodingError.dataCorrupted(.init(codingPath: typesContainer.codingPath, debugDescription: "Type x does not exist"))
        }
        
        let colors = try lineIdentifiers.map { identifier -> UIColor in
            let colorString = try colorsContainer.decode(String.self, forKey: identifier)
            guard let color = UIColor(hex: colorString) else {
                throw DecodingError.dataCorrupted(.init(codingPath: colorsContainer.codingPath + [identifier], debugDescription: "Invalid color"))
            }
            
            return color
        }
        
        let names = try lineIdentifiers.map {
            try namesContainer.decode(String.self, forKey: $0)
        }
        
        let (xValues, lineValues) = try ChartData.decodeColumns(container: &columnsContainer,
                                                                xIdentifier: xIdentifier,
                                                                lineIdentifiers: lineIdentifiers)
        
        self.xValues = xValues
        
        columns = (0..<lineIdentifiers.count).map { index -> Column in
            let name = names[index]
            let color = colors[index]
            let values = lineValues[index]
            
            return Column(name: name, color: color, values: values)
        }
    }
    
    private static func decodeColumns(container: inout UnkeyedDecodingContainer,
                                      xIdentifier: DynamicCodingKey,
                                      lineIdentifiers: [DynamicCodingKey]) throws -> (xValues: [TimeInterval], lineValues: [[Double]]) {
        var xValues: [TimeInterval] = []
        var lineValues = [[Double]](repeating: [Double](), count: lineIdentifiers.count)
        
        while !container.isAtEnd {
            var columnContainer = try container.nestedUnkeyedContainer()
            
            let identifier = try columnContainer.decode(String.self)
            var values: [Double] = []
            
            while !columnContainer.isAtEnd {
                values.append(try columnContainer.decode(Double.self))
            }
            
            if xIdentifier.stringValue == identifier {
                xValues = values
            } else {
                guard let index = lineIdentifiers.firstIndex(where: { $0.stringValue == identifier } ) else {
                    break
                }
                
                lineValues[index] = values
            }
        }
        
        return (xValues: xValues, lineValues: lineValues)
    }
}
