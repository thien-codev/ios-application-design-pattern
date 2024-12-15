//
//  StaticStrategy.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 15/12/24.
//

import Foundation

enum StaticStrategyOutputFormat
{
  case markdown
  case html
}

protocol StaticStrategyListStrategy
{
  init()
  func start(_ buffer: inout String)
  func end(_ buffer: inout String)
  func addListItem(buffer: inout String, item: String)
}

class StaticStrategyMarkdownListStrategy : StaticStrategyListStrategy
{
  required init() {}
  func start(_ buffer: inout String) {}
  func end(_ buffer: inout String) {}
  func addListItem(buffer: inout String, item: String)
  {
    buffer.append(" * \(item)\n")
  }
}

class StaticStrategyHtmlListStrategy : StaticStrategyListStrategy
{
  required init() {}
  func start(_ buffer: inout String)
  {
    buffer.append("<ul>\n")
  }

  func end(_ buffer: inout String)
  {
    buffer.append("</ul>\n")
  }

  func addListItem(buffer: inout String, item: String)
  {
    buffer.append("  <li>\(item)</li>\n")
  }
}

class StaticStrategyTextProcessor<LS> : CustomStringConvertible
  where LS : StaticStrategyListStrategy
{
  private var buffer = ""
  private let listStrategy = LS()

  func appendList(_ items: [String])
  {
    listStrategy.start(&buffer)
    for item in items
    {
      listStrategy.addListItem(buffer: &buffer, item: item)
    }
    listStrategy.end(&buffer)
  }

  var description: String
  {
    return buffer
  }
}

func mainStaticStrategy()
{
  // you cannot change the behavior of 'tp' after it's declared
  let tp = StaticStrategyTextProcessor<StaticStrategyMarkdownListStrategy>()
  tp.appendList(["foo", "bar", "baz"])
  print(tp.description)

  let tp2 = StaticStrategyTextProcessor<StaticStrategyHtmlListStrategy>()
  tp2.appendList(["foo", "bar", "baz"])
  print(tp2.description)
}
