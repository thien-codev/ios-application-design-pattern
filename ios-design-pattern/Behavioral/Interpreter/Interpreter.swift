//
//  Interpreter.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
Interpreter: a component which
processes structured text data and it does so by a two stage process.
So the first part of that stage is it takes the text and it splits it into separate lexical tokens.
And this is called Lexing.
And then there is the second part, which interprets the sequence of tokens into an object oriented
structure.
And this is called parsing.
 */

import Foundation

// allow the use of an indexer
extension String
{
  subscript (i: Int) -> Character
  {
    return self[index(startIndex, offsetBy: i)]
  }

  var isNumber : Bool
  {
    get {
      return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
  }
}

protocol Element
{
  var value: Int { get }
}

class Integer : Element
{
  var value: Int
  init(_ value: Int){
    self.value = value
  }
}

class BinaryOperation : Element
{
  enum OpType
  {
    case addition
    case subtraction
  }

  var opType: OpType
  var left: Element
  var right: Element

  init()
  {
    // dummy values
    opType = OpType.addition
    left = Integer(0)
    right = Integer(0)
  }

  init(left: Element, right: Element, opType: OpType)
  {
    self.left = left
    self.right = right
    self.opType = opType
  }

  var value: Int {
    switch (opType)
    {
      case OpType.addition:
        return left.value + right.value
      case OpType.subtraction:
        return left.value - right.value
    }
  }
}

struct Token : CustomStringConvertible
{
  enum TokenType
  {
    case integer
    case plus
    case minus
    case lparen
    case rparen
  }

  var tokenType: TokenType
  var text: String

  init(_ tokenType: TokenType, _ text: String)
  {
    self.tokenType = tokenType
    self.text = text
  }

  var description: String
  {
    return "`\(text)`"
  }
}


func lex(_ input: String) -> [Token]
{
  var result = [Token]()

  var i = 0 // need a mutable iterable variable
  while i < input.count
  {
    switch (input[i])
    {
      case "+":
        result.append(Token(Token.TokenType.plus, "+"))
      case "-":
        result.append(Token(Token.TokenType.minus, "-"))
      case "(":
        result.append(Token(Token.TokenType.lparen, "("))
      case ")":
        result.append(Token(Token.TokenType.rparen, ")"))
      default:
        var s = String(input[i])
        for j in (i+1)..<input.count
        {
          if String(input[j]).isNumber
          {
            s.append(input[j])
            i += 1
          }
          else
          {
            result.append(Token(Token.TokenType.integer, s))
            break
          }
        }
    }
    i += 1
  }
  return result
}

func parse(_ tokens: [Token]) -> Element
{
  let result = BinaryOperation()
  var haveLHS = false

  var i = 0
  while i < tokens.count
  {
    let token = tokens[i]
    switch (token.tokenType)
    {
      case Token.TokenType.integer:
        let integer = Integer(Int(token.text)!)
        if !haveLHS
        {
          result.left = integer
          haveLHS = true
        }
        else
        {
          result.right = integer
        }
      case Token.TokenType.plus:
        result.opType = BinaryOperation.OpType.addition
      case Token.TokenType.minus:
        result.opType = BinaryOperation.OpType.subtraction
      case Token.TokenType.lparen:
        var j = i
        while j < tokens.count
        {
          if tokens[j].tokenType == Token.TokenType.rparen
          {
            break
          }
          j += 1
        }
        // process subexpression without opening (
        let subexpression = tokens[(i+1)..<j]
        let element = parse(Array(subexpression))
        if !haveLHS
        {
          result.left = element
          haveLHS = true;
        }
        else {
          result.right = element;
        }
        i = j // advance
      default: break
    }
    i += 1
  }
  return result
}


func mainDD()
{
  let input = "(13+4)-(12+1)"
  let tokens = lex(input)
  print(tokens.map { $0.description }.joined(separator: "\t"))

  let parsed = parse(tokens)
  print("\(input) = \(parsed.value)")
}

// Test
extension String
{
  func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>]
  {
    var result: [Range<Index>] = []
    var start = startIndex
    while let range = range(of: string, options: options, range: start..<endIndex)
    {
      result.append(range)
      start = range.upperBound
    }
    return result
  }

  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }

  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
      return self[Range(start ... end)]
  }
}

class ExpressionProcessor
{
  var variables = [Character:Int]()

  enum NextOp
  {
    case nothing
    case plus
    case minus
  }

  func calculate(_ expression: String) -> Int
  {
    var current = 0
    var nextOp = NextOp.nothing

    var parts = [String]()
    var buffer = ""

    // regex lookbehind in swift is broken, so we split the strings by hand
    for c in expression
    {
      buffer.append(c)
      if (c == "+" || c == "-")
      {
        parts.append(buffer)
        buffer = ""
      }
    }
    if !buffer.isEmpty { parts.append(buffer) }

    for part in parts
    {
      var noOp = part.split { ["+", "-"]
        .contains(String($0)) }
      var value = 0
      var first = String(noOp[0])

      if let z = Int(first)
      {
        value = z
      }
      else if (first.utf8.count == 1 && variables[first[0]] != nil)
      {
        value = variables[first[0]]!
      }
      else
      {
        return 0
      }

      switch nextOp
      {
        case .nothing:
          current = value
        case .plus:
          current += value
        case .minus:
          current -= value
      }

      if part.hasSuffix("+")
      {
        nextOp = .plus
      }
      else if part.hasSuffix("-")
      {
        nextOp = .minus
      }
    }

    return current
  }
}

// SUMMARY
/*
 All right, So let's try to summarize the interpreter design pattern.
 So with the exception of simple cases, an interpreter actually works in two stages.
 So first of all, there is Lexing, which takes a chunk of text and turns it into a sequence of tokens.
 And then there is parsing, which turns the sequence of tokens into meaningful, object oriented constructs
 that you can subsequently traverse and, for example, print or evaluate or whatever it is that you
 need to do with them.
 */
