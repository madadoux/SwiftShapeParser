//
//  Lexer.swift
//  Parser
//
//  Created by mohamed saeed on 1/12/20.
//  Copyright © 2020 mohamed saeed. All rights reserved.
//

import Foundation
protocol LexerProtocol {
    func tokenize(s:String) -> [String]
}

struct DefaultLexer: LexerProtocol  {
    func tokenize(s: String)-> [String] {
        var tokens = [String]()
        var i = s.startIndex
        var currentToken = ""
        while i < s.endIndex {
            if !s[i].isNumber && !s[i].isLetter {
                if (!currentToken.isEmpty) {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(s[i]))
            }
            else if ( s[i].isNumber){
                currentToken += String(s[i])
            }
            else if ( s[i].isLetter){
                currentToken += String(s[i])
            }
            i = s.index(after: i)
        }
        return tokens
    }
}
