//
//  TemplateMethod.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//


import Foundation

// no abstract classes, so we fail in abstract methods
class TemplateMethodGame
{
  func run() // this is the template method
  {
    start()
    while !haveWinner
    {
      takeTurn()
    }
    print("Player \(winningPlayer) wins!")
  }

  internal func start()
  {
    precondition(false, "this method needs to be overridden")
  }

  internal var haveWinner: Bool
  {
    get {
      precondition(false, "this method needs to be overridden")
    }
  }

  internal func takeTurn()
  {
    precondition(false, "this method needs to be overridden")
  }

  internal var winningPlayer: Int
  {
    get {
      precondition(false, "this method needs to be overridden")
    }
  }

  internal var currentPlayer = 0
  internal let numberOfPlayers: Int

  init(_ numberOfPlayers: Int)
  {
    self.numberOfPlayers = numberOfPlayers
  }
}

// simulate a game of chess
class TemplateMethodChess : TemplateMethodGame
{
  private let maxTurns = 10
  private var turn = 1

  init() {
    super.init(2)
  }

  override func start()
  {
    print("Starting a game of chess with \(numberOfPlayers) players.")
  }

  override var haveWinner: Bool
  {
    return turn == maxTurns
  }

  override func takeTurn()
  {
    print("Turn \(turn) taken by player \(currentPlayer).")
    currentPlayer = (currentPlayer + 1) % numberOfPlayers
    turn += 1
  }

  override var winningPlayer: Int
  {
    return currentPlayer
  }
}

func mainTemplateMethod()
{
  let chess = TemplateMethodChess()
  chess.run()
}

/*
 So let's try to summarize what we've learned about the template method design pattern.
 So what you do is you define an algorithm at a reasonably high level.
 You define its constituent parts as kind of abstract methods or indeed properties.
 And then you inherit this class and you provide the necessary overrides, thereby completing the algorithm.
 */
