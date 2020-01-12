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
    func parse(s:String) throws -> TreeNode<Shape>
}
protocol Shape  : class {
    static  func makeShape(value:Any) throws -> Shape
    static var startingSymbol : String { get  }
    static var endingSymbol : String { get  }
    func getValue ()->Any
    func canContainChild(_ innerShape:Shape)-> Bool
}

class ShapeBase : Shape,CustomStringConvertible {
    func canContainChild(_ innerShape: Shape) -> Bool {
        return true
    }
    class func makeShape(value: Any) throws -> Shape {
        return ShapeBase(val: value )
    }
    class var startingSymbol: String { "|"}
    class var endingSymbol: String { "|"}
    
    func getValue() -> Any {
        return value
    }
    
    var value :  Any
    init(val : Any) {
        value = val
    }
    public var description: String {
      return Self.startingSymbol + "\(getValue())" + Self.endingSymbol

      }
}
class CircleShape:  ShapeBase  {
    override func canContainChild(_ innerShape: Shape) -> Bool {
        return innerShape is CircleShape || innerShape is SquareShape
    }
    
    override class func makeShape(value: Any) throws -> Shape {
        if let val = value as? String {
            for c in val {
                if (c.isLowercase || !c.isLetter ){
                    throw ShapeErrors.invalidLabelFormat
                }
            }
            return  CircleShape(val: val)
        }
        throw ShapeErrors.valueDidnotMatch
    }
    
    override class var startingSymbol: String { "("}
    
    override class var endingSymbol: String { ")"}
    
}

class SquareShape:  ShapeBase {
    
    override func canContainChild(_ innerShape: Shape) -> Bool {
           return innerShape is SquareShape
    }
    override class func makeShape(value: Any) throws -> Shape {
        
        if let val = value as? String {
            for c in val {
                if (!c.isNumber ){
                    throw ShapeErrors.invalidLabelFormat
                }
            }
            return  SquareShape(val: val)
        }
        throw ShapeErrors.valueDidnotMatch
    }
    
    
    override class var startingSymbol: String { "["}
    
    override class var endingSymbol: String { "]"}
    
    
}

class TrinangleShape:  ShapeBase {
   
    override class func makeShape(value: Any) throws -> Shape {
         if let val = value as? String {
                   return  TrinangleShape(val: val)
               }
               throw ShapeErrors.valueDidnotMatch
    }
    override class var endingSymbol: String {">"}
    override class var startingSymbol: String {"<"}
}

