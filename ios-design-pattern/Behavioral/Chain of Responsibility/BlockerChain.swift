//
//  BlockerChain.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 15/12/24.
//

/*
 Now, one approach that we're going to be using, and I've already mentioned this is something called
 command query separation.
 Specifically, we're not going to deal with commands in this example, but I am going to show queries
 and we're going to see how querying a creature in a kind of broker centric, mediator centric way can
 be a better approach.
 */

import Foundation

// events required for this! (Observer pattern)
protocol Invocable: AnyObject
{
  func invoke(_ data: Any)
}

public protocol Disposable
{
  func dispose()
}

public class Event<T>
{
  public typealias EventHandler = (T) -> ()

  var eventHandlers = [Invocable]()

  public func raise(_ data: T)
  {
    for handler in self.eventHandlers
    {
      handler.invoke(data)
    }
  }

  public func addHandler<U: AnyObject>
    (target: U, handler: @escaping (U) -> EventHandler) -> Disposable
  {
    let subscription = Subscription(target: target, handler: handler, event: self)
    eventHandlers.append(subscription)
    return subscription
  }
}

class Subscription<T: AnyObject, U> : Invocable, Disposable
{
  weak var target: T?
  let handler: (T) -> (U) -> ()
  let event: Event<U>

  init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>)
  {
    self.target = target
    self.handler = handler
    self.event = event
  }

  func invoke(_ data: Any) {
    if let t = target {
      handler(t)(data as! U)
    }
  }

  func dispose()
  {
    event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
  }
}

// cqs = command query separation

class Query
{
  var creatureName: String
  enum Argument
  {
    case attack
    case defense
  }
  var whatToQuery: Argument
  var value: Int

  init(name: String, whatToQuery: Argument, value: Int)
  {
    self.creatureName = name
    self.whatToQuery = whatToQuery
    self.value = value
  }
}

class Game // mediator pattern
{
  let queries = Event<Query>()

  func performQuery(sender: AnyObject?, q: Query)
  {
    queries.raise(q)
  }
}

class BlockerCreature : CustomStringConvertible {
  var name: String
  private let _attack: Int
  private let _defense: Int
  private let game: Game

  init(game: Game, name: String, attack: Int, defense: Int) {
    self.game = game
    self.name = name
    _attack = attack
    _defense = defense
  }

  var attack: Int {
    let q = Query(name: name, whatToQuery: Query.Argument.attack, value: _attack)
    game.performQuery(sender: self, q: q)
    return q.value
  }

  var defense: Int {
    let q = Query(name: name, whatToQuery: Query.Argument.defense, value: _defense)
    game.performQuery(sender: self, q: q)
    return q.value
  }

  var description: String {
    return "Name: \(name), A = \(attack), D = \(defense)"
  }
}

class BlockerCreatureModifier : Disposable
{
  let game: Game
  let creature: BlockerCreature
  var event: Disposable? = nil

  init(_ game: Game, _ creature: BlockerCreature)
  {
    self.game = game
    self.creature = creature
    event = self.game.queries.addHandler(target: self, handler: BlockerCreatureModifier.handle)
  }

  func handle(q: Query)
  {
    // no abstract classes
    // implemented by descendant
  }

  func dispose()
  {
    event?.dispose()
  }
}

class BlockerDoubleAttackModifier: BlockerCreatureModifier
{
  override func handle(q: Query)
  {
    if (q.creatureName == creature.name && q.whatToQuery == Query.Argument.attack)
    {
      q.value *= 2
    }
  }
}

class BlockerIncreaseDefenseModifier : BlockerCreatureModifier
{
  override func handle(q: Query)
  {
    if (q.creatureName == creature.name &&
       q.whatToQuery == Query.Argument.defense)
    {
      q.value += 2
    }
  }
}

func mainK()
{
  let game = Game()
  let goblin = BlockerCreature(game: game, name: "Strong Goblin",
    attack: 3, defense: 3)
  print("Baseline goblin: \(goblin)")
  do
  {
    let _ = BlockerDoubleAttackModifier(game, goblin)
    print("Goblin with double attack: \(goblin)")

    do
    {
      let _ = BlockerIncreaseDefenseModifier(game, goblin)
      print("Goblin with 2x attack and inc def: \(goblin)")
    }
  }
}
