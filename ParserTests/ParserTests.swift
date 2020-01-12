//
//  ParserTests.swift
//  ParserTests
//
//  Created by mohamed saeed on 1/12/20.
//  Copyright © 2020 mohamed saeed. All rights reserved.
//

import XCTest
@testable import Parser

class ParserTests: XCTestCase {

   func test_lexer () {
        let lexer = DefaultLexer()
    let string = "[12](BALL(INK[1[35]](CHARLIE)))"
    let tokens = lexer.tokenize(s: string)
    let expectedTokens = ["[","12","]","(","BALL","(","INK","[","1","[","35","]","]","(","CHARLIE",")",")",")"]
    XCTAssert(tokens.count == expectedTokens.count,"invalid length")
    for i in 0..<expectedTokens.count {
        XCTAssert(tokens[i].token == expectedTokens[i] , "invalid at pos \(i)")
    }
    
    }
    
    
    func test_tree () {
        let tree = TreeNode<String>(value: "beverages")

        let hotNode = TreeNode<String>(value: "hot")
        let coldNode = TreeNode<String>(value: "cold")

        let teaNode = TreeNode<String>(value: "tea")
        let coffeeNode = TreeNode<String>(value: "coffee")
        let chocolateNode = TreeNode<String>(value: "cocoa")

        let blackTeaNode = TreeNode<String>(value: "black")
        let greenTeaNode = TreeNode<String>(value: "green")
        let chaiTeaNode = TreeNode<String>(value: "chai")

        let sodaNode = TreeNode<String>(value: "soda")
        let milkNode = TreeNode<String>(value: "milk")

        let gingerAleNode = TreeNode<String>(value: "ginger ale")
        let bitterLemonNode = TreeNode<String>(value: "bitter lemon")

        tree.addChild(hotNode)
        tree.addChild(coldNode)

        hotNode.addChild(teaNode)
        hotNode.addChild(coffeeNode)
        hotNode.addChild(chocolateNode)

        coldNode.addChild(sodaNode)
        coldNode.addChild(milkNode)

        teaNode.addChild(blackTeaNode)
        teaNode.addChild(greenTeaNode)
        teaNode.addChild(chaiTeaNode)

        sodaNode.addChild(gingerAleNode)
        sodaNode.addChild(bitterLemonNode)
        XCTAssert ( tree.description == "beverages {hot {tea {black, green, chai}, coffee, cocoa}, cold {soda {ginger ale, bitter lemon}, milk}}");
    }
    
    func test_stack_empty() {
      var stack = Stack<Int>()
      XCTAssertTrue(stack.isEmpty)
      XCTAssertEqual(stack.count, 0)
      XCTAssertEqual(stack.top, nil)
      XCTAssertNil(stack.pop())
    }

    func test_stack_one_element() {
      var stack = Stack<Int>()

      stack.push(123)
      XCTAssertFalse(stack.isEmpty)
      XCTAssertEqual(stack.count, 1)
      XCTAssertEqual(stack.top, 123)

      let result = stack.pop()
      XCTAssertEqual(result, 123)
      XCTAssertTrue(stack.isEmpty)
      XCTAssertEqual(stack.count, 0)
      XCTAssertEqual(stack.top, nil)
      XCTAssertNil(stack.pop())
    }

    func test_stack_two_element() {
      var stack = Stack<Int>()

      stack.push(123)
      stack.push(456)
      XCTAssertFalse(stack.isEmpty)
      XCTAssertEqual(stack.count, 2)
      XCTAssertEqual(stack.top, 456)

      let result1 = stack.pop()
      XCTAssertEqual(result1, 456)
      XCTAssertFalse(stack.isEmpty)
      XCTAssertEqual(stack.count, 1)
      XCTAssertEqual(stack.top, 123)

      let result2 = stack.pop()
      XCTAssertEqual(result2, 123)
      XCTAssertTrue(stack.isEmpty)
      XCTAssertEqual(stack.count, 0)
      XCTAssertEqual(stack.top, nil)
      XCTAssertNil(stack.pop())
    }

    func test_stack_make_empty() {
      var stack = Stack<Int>()

      stack.push(123)
      stack.push(456)
      XCTAssertNotNil(stack.pop())
      XCTAssertNotNil(stack.pop())
      XCTAssertNil(stack.pop())

      stack.push(789)
      XCTAssertEqual(stack.count, 1)
      XCTAssertEqual(stack.top, 789)

      let result = stack.pop()
      XCTAssertEqual(result, 789)
      XCTAssertTrue(stack.isEmpty)
      XCTAssertEqual(stack.count, 0)
      XCTAssertEqual(stack.top, nil)
      XCTAssertNil(stack.pop())
    }
    

    
    func test_parser () {
        let lexer = DefaultLexer()
          let string = "[12](BALL(INK[1[35]](CHARLIE)))"
        let parser = DefaultParser(lexer)
        parser.regiterShape(shape: CircleShape.self)
        parser.regiterShape(shape: SquareShape.self)

        do {
          let container =  try parser.parse(s: string)
            print(container)
        }
        catch {
            print(error)
            XCTFail()
        }
        
    }
    func test_parser_invalid_input () {
         let lexer = DefaultLexer()
           let string = "%#@"
         let parser = DefaultParser(lexer)
         parser.regiterShape(shape: CircleShape.self)
         parser.regiterShape(shape: SquareShape.self)

         do {
           let container =  try parser.parse(s: string)
             print(container)
            XCTFail()

         }
         catch {
             print(error)
         }
         
     }
    
    func test_parser_invalid_input_2 () {
           let lexer = DefaultLexer()
             let string = "[12](BALL(SOUL)*&#"
           let parser = DefaultParser(lexer)
           parser.regiterShape(shape: CircleShape.self)
           parser.regiterShape(shape: SquareShape.self)

           do {
             let container =  try parser.parse(s: string)
             print(container)
             XCTFail()

           }
           catch {
               print(error)
           }
           
       }
    func test_parser_missmatching_complement_token () {
          let lexer = DefaultLexer()
          let string = "[12)(BALL(INK[1[35]](CHARLIE)))"
          let parser = DefaultParser(lexer)
          parser.regiterShape(shape: CircleShape.self)
          parser.regiterShape(shape: SquareShape.self)
        let exp = self.expectation(description: "mismatching complement")
          do {
            _ =  try parser.parse(s: string)
          }
          catch ShapeErrors.maliformedInput {
            exp.fulfill()
          }
          catch {
            XCTFail()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
      }
    func test_parser_missmatching_complement_token_2 () {
             let lexer = DefaultLexer()
             let string = "[12](BALL(INK[1[35]](CHARLIE])"
             let parser = DefaultParser(lexer)
             parser.regiterShape(shape: CircleShape.self)
             parser.regiterShape(shape: SquareShape.self)
           let exp = self.expectation(description: "mismatching complement")
             do {
               _ =  try parser.parse(s: string)
             }
             catch ShapeErrors.maliformedInput {
               exp.fulfill()
             }
             catch {
               XCTFail()
           }
           
           waitForExpectations(timeout: 0.5, handler: nil)
           
         }
    
    func test_parser_one_shape() {
        let lexer = DefaultLexer()
        let string = "[12]"
        let parser = DefaultParser(lexer)
        parser.regiterShape(shape: CircleShape.self)
        parser.regiterShape(shape: SquareShape.self)
        do {
          let container =  try parser.parse(s: string)
            print(container)
        }
        catch {
          XCTFail()
      }
      
      
    }
    func test_parser_one_shape2() {
           let lexer = DefaultLexer()
           let string = "(BALL)"
           let parser = DefaultParser(lexer)
           parser.regiterShape(shape: CircleShape.self)
           parser.regiterShape(shape: SquareShape.self)
           do {
             let container =  try parser.parse(s: string)
               print(container)
           }
           catch {
             XCTFail()
         }
         
         
       }
    func test_parser_extra_tokens () {
                let lexer = DefaultLexer()
                let string = "[12]]]"
                let parser = DefaultParser(lexer)
                parser.regiterShape(shape: CircleShape.self)
                parser.regiterShape(shape: SquareShape.self)
              let exp = self.expectation(description: "mismatching complement")
                do {
                  _ =  try parser.parse(s: string)
                }
                catch ShapeErrors.maliformedInput {
                  exp.fulfill()
                }
                catch {
                  XCTFail()
              }
              
              waitForExpectations(timeout: 0.5, handler: nil)
              
            }
    func test_parser_circle_lowerCase () {
           let lexer = DefaultLexer()
             let string = "[12](bALL(INK[1[35]](CHARLIE)))"
           let parser = DefaultParser(lexer)
           parser.regiterShape(shape: CircleShape.self)
           parser.regiterShape(shape: SquareShape.self)
        let exp = self.expectation(description: "invalidValueFormat")

           do {
             let container =  try parser.parse(s: string)
               print(container)
           }
           catch ShapeErrors.invalidLabelFormat {
            exp.fulfill()
           }
           catch {
               print(error)
               XCTFail()
           }
        waitForExpectations(timeout: 0.5, handler: nil)

           
       }
    
    func test_parser_square_letters_not_numbers () {
           let lexer = DefaultLexer()
             let string = "[square](BALL(INK[1[35]](CHARLIE)))"
           let parser = DefaultParser(lexer)
           parser.regiterShape(shape: CircleShape.self)
           parser.regiterShape(shape: SquareShape.self)
        let exp = self.expectation(description: "invalidValueFormat")

           do {
             let container =  try parser.parse(s: string)
               print(container)
           }
           catch ShapeErrors.invalidLabelFormat {
            exp.fulfill()
           }
           catch {
               print(error)
               XCTFail()
           }
        waitForExpectations(timeout: 0.5, handler: nil)

           
       }
    
    
    func test_parser_square_should_not_contain_circle() {
              let lexer = DefaultLexer()
                let string = "[12](BALL(INK[1(HALL)](CHARLIE)))"
              let parser = DefaultParser(lexer)
              parser.regiterShape(shape: CircleShape.self)
              parser.regiterShape(shape: SquareShape.self)
           let exp = self.expectation(description: "contain_circle")

              do {
                let container =  try parser.parse(s: string)
                  print(container)
              }
              catch ShapeErrors.invalidInnerShape {
               exp.fulfill()
              }
              catch {
                  print(error)
                  XCTFail()
              }
           waitForExpectations(timeout: 0.5, handler: nil)

              
          }

    func test_parser_adding_new_shape_1() {
                let lexer = DefaultLexer()
                  let string = "[12](BALL(INK[1[35]](CHARLIE)))<happy<flappy>>"
                let parser = DefaultParser(lexer)
                parser.regiterShape(shape: CircleShape.self)
                parser.regiterShape(shape: SquareShape.self)
                parser.regiterShape(shape: TrinangleShape.self)
                do {
                  let container =  try parser.parse(s: string)
                    print(container)
                }
              
                catch {
                    print(error)
                    XCTFail()
                }
                
            }

    func test_parser_adding_new_shape_2() {
                let lexer = DefaultLexer()
                  let string = "[12](BALL(INK[1[35]](CHARLIE)))<happy<flappy(CALL)>>"
                let parser = DefaultParser(lexer)
                parser.regiterShape(shape: CircleShape.self)
                parser.regiterShape(shape: SquareShape.self)
                parser.regiterShape(shape: TrinangleShape.self)
                do {
                  let container =  try parser.parse(s: string)
                    print(container)
                }
              
                catch {
                    print(error)
                    XCTFail()
                }
                
            }
    
    

}
