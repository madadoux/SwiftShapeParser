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
protocol Shape  : class {
    static  func makeShape(value:Any) throws -> Shape
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

class ShapeBase : Shape {
    class func makeShape(value: Any) throws -> Shape {
        return ShapeBase(val: value )
    }
    class var startingSymbol: String { "{"}
    class var endingSymbol: String { "}"}
    
    func getValue() -> Any {
        return treeNode.value
    }
    
    private var treeNode : TreeNode<Any>
    init(val : Any) {
        treeNode = TreeNode<Any>(value: val)
    }
    
}
class CircleShape:  ShapeBase  {
    
    override class func makeShape(value: Any) throws -> Shape {
        if let val = value as? String {
            for c in val {
                if (c.isLowercase || !c.isLetter ){
                    throw ShapeErrors.invalidValueFormat
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
    
    override class func makeShape(value: Any) throws -> Shape {
        
        if let val = value as? String {
            for c in val {
                if (!c.isNumber ){
                    throw ShapeErrors.invalidValueFormat
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

