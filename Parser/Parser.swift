//
//  Parser.swift
//  Parser
//
//  Created by mohamed saeed on 1/12/20.
//  Copyright © 2020 mohamed saeed. All rights reserved.
//

import Foundation

enum ShapeErrors : Error {
    case valueDidnotMatch
    case shapeNotRegistered
    case notComplementToken
}


class DefaultParser : ParserProtocol {
    
    
    private var registeredShapes = [String:Shape.Type]()
    private var tokenComplement = [String:String]()
    private let lexer : LexerProtocol
    init(_ lexer : LexerProtocol) {
        self.lexer = lexer
    }
    
    func makeTreeOf(s: String) throws -> TreeNode<Shape> {
        var shapesStack = Stack<TreeNode<Shape>>()
        var tokensStack = Stack<String>()
        let container = TreeNode<Shape>(value: CircleShape(val:"root"))
        shapesStack.push(container)
        let tokens = lexer.tokenize(s: s)
        var i = 0
        while  i < tokens.count {
            let shape = identifyShape(token: tokens[i])
            if let  shape = shape {
                let generatedShape =  try shape.makeShape(value: tokens[i+1])
                print("current shape :\(generatedShape.getRepresentation())")
                
                shapesStack.push(TreeNode<Shape>(value:generatedShape))
                tokensStack.push(tokens[i])
                i = i + 1
            }
            else {
                //check top
                if let topToken = tokensStack.top  {
                    if isTokenIsComplementOfToken(a:topToken  , b: tokens[i]) {
                        let popedShape = shapesStack.pop()!
                        _ = tokensStack.pop()
                        if let topShape = shapesStack.top {
                            topShape.addChild(popedShape)
                        }
                    }
                    else {
                        throw ShapeErrors.notComplementToken
                    }
                }
            }
            
            i = i + 1
            
        }
        
        return container
    }
    
    func isTokenIsComplementOfToken( a:String , b:String)->Bool {
        let complementToken =  tokenComplement[a]
        return  complementToken != nil && complementToken == b;
    }
    
    func regiterShape(shape:Shape.Type) {
        registeredShapes[shape.startingSymbol] = shape
        tokenComplement [shape.startingSymbol] = shape.endingSymbol
    }
    
    func identifyShape(token:String ) -> Shape.Type? {
        let shape =   registeredShapes[token]
        return shape
    }
}
