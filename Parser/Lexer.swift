//
//  Lexer.swift
//  Parser
//
//  Created by mohamed saeed on 1/12/20.
//  Copyright © 2020 mohamed saeed. All rights reserved.
//

import Foundation
enum TokenType {
    case symbol
    case label
}
struct Token {
    let token : String
    let type : TokenType
}
protocol LexerProtocol {
    func tokenize(s:String) -> [Token]
}

struct DefaultLexer: LexerProtocol  {
    func tokenize(s: String)-> [Token] {
        var tokens = [Token]()
        var i = s.startIndex
        var currentToken = ""
        while i < s.endIndex {
            if !s[i].isNumber && !s[i].isLetter {
                if (!currentToken.isEmpty) {
                    tokens.append(Token(token: currentToken, type: .label))
                    currentToken = ""
                }
                tokens.append(Token(token:String(s[i]) , type: .symbol) )
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
