//
//  NullObject.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
  A behaviour design pattern with no behaviour :V
 "
 So the null object is quite simply a no op object.
 So an object which does absolutely nothing but an object which conforms to the required interface,
 satisfying a dependency requirement of some other object."
 */

protocol Log
{
  func info(_ msg: String)
  func warn(_ msg: String)
}

class ConsoleLog : Log
{
  func info(_ msg: String)
  {
    print(msg)
  }

  func warn(_ msg: String)
  {
    print("WARNING: \(msg)")
  }
}

class NullObjectBankAccount
{
  var log: Log
  var balance = 0

  init(_ log: Log)
  {
    self.log = log
  }

  func deposit(_ amount: Int)
  {
    balance += amount
    // check for null everywhere?
    log.info("Deposited \(amount), balance is now \(balance)")
  }

  func withdraw(_ amount: Int)
  {
    if (balance >= amount)
    {
      balance -= amount
      log.info("Withdrew \(amount), we have \(balance) left")
    }
    else
    {
      log.warn("Could not withdraw \(amount) because balance is only \(balance)")
    }
  }
}

class NullLog : Log
{
  func info(_ msg: String) {}
  func warn(_ msg: String) {}
}

func mainNullObject()
{
  //let log = ConsoleLog()
  //let log = nil
  let log = NullLog()
  let ba = NullObjectBankAccount(log)
  ba.deposit(100)
  ba.withdraw(200)
}

/*
 SUMMANY:
 - Implement right interface
 - but rewrite with empty body
 */
