//
//  Visitor.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

import Foundation

protocol Expression
{
  func print(_ buffer: inout String)
}

class DoubleExpression : Expression
{
  private var value: Double
  init(_ value: Double)
  {
    self.value = value
  }
  func print(_ buffer: inout String)
  {
    buffer.append(String(value))
  }
}

class AdditionExpression : Expression
{
  private var left: Expression
  private var right: Expression

  init(_ left: Expression, _ right: Expression)
  {
    self.left = left
    self.right = right
  }

  func print(_ buffer: inout String)
  {
    buffer.append("(")
    left.print(&buffer)
    buffer.append("+")
    right.print(&buffer)
    buffer.append(")")
  }
}

func mainVisitor()
{
  let e = AdditionExpression(
    DoubleExpression(1),
    AdditionExpression(
      DoubleExpression(2),
      DoubleExpression(3)
    )
  )
  var s = ""
  e.print(&s)
  print(s)
}
