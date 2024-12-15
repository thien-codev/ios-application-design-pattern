//
//  Flyweight.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Flyweight:
    - Avoid redundancy when store data
 
 "So the flyweight is a space optimization technique that lets you use less memory by storing externally
 some data associated with similar objects.
 */

// The goal of Flyweight: Save memory

import Foundation

class User {
    var fullname: String
    init(fullname: String) {
        self.fullname = fullname
    }
    
    var charCount: Int {
        return fullname.utf8.count
    }
}

// Try to detect how many memory wasted
/*
 let user1 = User(fullname: "John Smith")
 let user2 = User(fullname: "Jane Smith")
 let user3 = User(fullname: "Jane Doe")
 
 let totalChars = user1.charCount + user2.charCount + user3.charCount
 
 
 It's easy to see there are some duplicated chars
 Now the Flyweight come into play
 */
// Flyweight used
class FlyweightUser {
    static var strings = [String]()
    private var names = [Int]()
    
    init(fullname: String) {

        func getOrAdd(_ s: String) -> Int
        {
            if let idx = type(of: self).strings.firstIndex(of: s)
          {
            return idx
          }
          else
          {
            type(of: self).strings.append(s)
            return type(of: self).strings.count + 1
          }
        }
        names = fullname.components(separatedBy: " ").map { getOrAdd($0) }
    }
    
    var charCount: Int {
        return FlyweightUser.strings.map{ $0.utf8.count }.reduce(0, +)
    }
}

// Text formatting example
extension String {
    
    func substring(_ location: Int, _ length: Int) -> String? {
        guard count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: location + length)
        return substring(with: start..<end)
    }
}

class FormattedText: CustomStringConvertible
{
  private var text: String
  private var capitalize: [Bool]

  init(_ text: String)
  {
    self.text = text
    capitalize = [Bool](repeating: false, count: text.utf8.count)
  }
  
  func capitalize(_ start: Int, _ end: Int)
  {
    for i in start...end
    {
      capitalize[i] = true
    }
  }

  var description: String
  {
    var s = ""
    for i in 0..<text.utf8.count
    {
      let c = text.substring(i,1)!
      s += capitalize[i] ? c.capitalized : c
    }
    return s
  }
}

class BetterFormattedText: CustomStringConvertible
{
  private var text: String
  private var formatting = [TextRange]()

  init(_ text: String)
  {
    self.text = text
  }

  func getRange(_ start: Int, _ end: Int) -> TextRange
  {
    let range = TextRange(start, end)
    formatting.append(range)
    return range
  }

  var description: String
  {
    var s = ""
    for i in 0..<text.utf8.count
    {
      var c = text.substring(i, 1)!
      for range in formatting
      {
        if range.covers(i) && range.capitalize
        {
          c = c.capitalized
        }
      }
      s += c
    }
    return s
  }

  class TextRange
  {
    var start, end: Int
    var capitalize: Bool = false // bold, italic, etc

    init(_ start: Int, _ end: Int)
    {
      self.start = start
      self.end = end
    }

    func covers(_ position: Int) -> Bool
    {
      return position >= start && position <= end
    }
  }
}

func mainE()
{
  let ft = FormattedText("This is a brave new world")
  ft.capitalize(10,15)
  print(ft)

  let bft = BetterFormattedText("This is a brave new world")
  bft.getRange(10,15).capitalize = true
  print(bft)
}

// test
//import XCTest
/*
 You are given a class called Sentence , which takes a string such as "hello world". You need to provide an interface such that the subscript of the class returns a WordToken  which can be used to capitalize a particular word in the sentence.
 Typical use would be something like:
 var sentence = Sentence("hello world")
 sentence[1].capitalize = true
 print(sentence); // writes "hello WORLD"
 */

class Sentence : CustomStringConvertible
{
  var words: [String]
  var tokens = [Int: WordToken]()

  init(_ plainText: String)
  {
    words = plainText.components(separatedBy: " ")
  }

  subscript(index: Int) -> WordToken
  {
    get
    {
      let wt = WordToken()
      tokens[index] = wt
      return tokens[index]!
    }
  }

  var description: String
  {
    var ws = [String]()
    for i in 0..<words.count
    {
      var w = words[i]
      if let item = tokens[i]
      {
        if (item.capitalize)
        {
          w = w.uppercased()
        }
      }
      ws.append(w)
    }
    return ws.joined(separator: " ")
  }

  class WordToken
  {
    var capitalize: Bool = false
    init(){}
    init(capitalize: Bool)
    {
      self.capitalize = capitalize
    }
  }
}

