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
    case maliformedInput
    case invalidLabelFormat
    case invalidInnerShape
    case invalidInput
}


class DefaultParser : ParserProtocol {
    
    
    private var registeredShapes = [String:Shape.Type]()
    private var tokenComplement = [String:String]()
    private let lexer : LexerProtocol
    init(_ lexer : LexerProtocol) {
        self.lexer = lexer
    }
    func parse(s: String) throws -> TreeNode<Shape> {
        var shapesStack = Stack<TreeNode<Shape>>()
        var tokensStack = Stack<String>()
        let container = TreeNode<Shape>(value: ShapeBase(val:"root"))
        shapesStack.push(container)
        let tokens = lexer.tokenize(s: s)
        var i = 0
        if (tokens.count < 2 ) {
            throw ShapeErrors.invalidInput
        }
        while  i < tokens.count {
            let shape = identifyShape(token: tokens[i].token)
            
            if let shape = shape {
                let generatedShape =  try shape.makeShape(value: tokens[i+1].token)
                print("current shape :\(generatedShape.getRepresentation())")
                
                shapesStack.push(TreeNode<Shape>(value:generatedShape))
                tokensStack.push(tokens[i].token)
                i = i + 1
            }
            else {
                
                
                
                if let topToken = tokensStack.top  , isTokenIsComplementOfToken(a:topToken  , b: tokens[i].token) {
                    let popedShape = shapesStack.pop()!
                    _ = tokensStack.pop()
                    if let topShape = shapesStack.top {
                        if (topShape.value.canContainChild(popedShape.value)) {
                            topShape.addChild(popedShape)
                        }
                        else {
                            throw ShapeErrors.invalidInnerShape
                        }
                    }
                }
                else {
                    if (tokens[i].type == .symbol && !isTokenRegonized(a:  tokens[i].token))
                    {
                        throw ShapeErrors.invalidInput
                    }
                    else {
                        throw ShapeErrors.maliformedInput
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
    func isTokenRegonized( a:String)->Bool {
        let t =  tokenComplement[a]
        return  t != nil || tokenComplement.values.contains(a)
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
