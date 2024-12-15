//
//  State.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
the state design pattern is basically a pattern where the objects behavior is determined by its state,
 kind of like my behavior is determined by my state.
 */

import Foundation

enum State
{
  case offHook
  case connecting
  case connected
  case onHold
}

enum Trigger
{
  case callDialed
  case hungUp
  case callConnected
  case placedOnHold
  case takenOffHold
  case leftMessage
}

let rules = [
  State.offHook: [
    (Trigger.callDialed, State.connecting)
  ],
  State.connecting: [
    (Trigger.hungUp, State.offHook),
    (Trigger.callConnected, State.connected)
  ],
  State.connected: [
    (Trigger.leftMessage, State.offHook),
    (Trigger.hungUp, State.offHook),
    (Trigger.placedOnHold, State.onHold)
  ],
  State.onHold: [
    (Trigger.takenOffHold, State.connected),
    (Trigger.hungUp, State.offHook)
  ]
]

func mainState()
{
  var state = State.offHook // starting state
  while true
  {
    print("The phone is currently \(state)")
    print("Select a trigger:")

    for i in 0..<rules[state]!.count
    {
      let (t, _) = rules[state]![i]
      print("\(i). \(t)")
    }

    if let input = Int(readLine()!)
    {
      let (_, s) = rules[state]![input]
      state = s
    }
  }
}
