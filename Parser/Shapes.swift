//
//  Shapes.swift
//  Parser
//
//  Created by mohamed saeed on 1/12/20.
//  Copyright © 2020 mohamed saeed. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    //returns root
    func makeTreeOf(s:String) throws -> TreeNode<Shape>
}
protocol Shape  {
    static func makeShape(value:Any) throws -> Shape
    static var startingSymbol : String { get  }
    static var endingSymbol : String { get  }
    func getRepresentation() -> String
    func getValue ()->Any
}

extension Shape  {
    public func getRepresentation() ->  String  {
        return Self.startingSymbol + "\(getValue())" + Self.endingSymbol
    }
   
}

class ShapeBase {
    
}
class CircleShape:  Shape {
    func getValue() -> Any {
        return value
    }
    
    var value :  String
    init(val : String) {
        value = val
    }
    static func makeShape(value: Any) throws -> Shape {
        // I will implement shape rules here
        if let val = value as? String {
            return  CircleShape(val: val)
        }
        throw ShapeErrors.valueDidnotMatch
    }
    
    
    static var startingSymbol: String { "("}
    
    static var endingSymbol: String { ")"}
    
}

class SquareShape:  Shape {
    var value :  String
    init(val : String) {
        value = val
    }
    static func makeShape(value: Any) throws -> Shape {
        // I will implement shape rules here

        if let val = value as? String {
            
            return  SquareShape(val: val)
        }
        throw ShapeErrors.valueDidnotMatch
    }
    
    
    static var startingSymbol: String { "["}
    
    static var endingSymbol: String { "]"}
    func getValue() -> Any {
        return value
    }
    
}

class TrinangleShape:  Shape {
    var value :  String
    init(val : String) {
        value = val
    }
    static func makeShape(value: Any) throws -> Shape {
        // I will implement shape rules here

        if let val = value as? String {
            
            return  TrinangleShape(val: val)
        }
        throw ShapeErrors.valueDidnotMatch
    }
    
    
    static var startingSymbol: String { "{"}
    
    static var endingSymbol: String { "}"}
    func getValue() -> Any {
        return value
    }
    
}

