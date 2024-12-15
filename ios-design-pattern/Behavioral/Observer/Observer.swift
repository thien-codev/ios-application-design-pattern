//
//  Observer.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//
/*
 REASON:
    - inform when certain things happen
        - property changed
        - object do something
        - some external event occur
    - listen and notify when event occur
 */

import Foundation

protocol ObserverInvocable
{
  func invoke(_ data: Any)
}

public protocol ObserverDisposable
{
  func dispose()
}

public class ObserverEvent<T>
{
  public typealias ObserverEventHandler = (T) -> ()

  var eventHandlers = [ObserverInvocable]()

  public func raise(_ data: T)
  {
    for handler in eventHandlers
    {
      handler.invoke(data)
    }
  }

  public func addHandler<U: AnyObject>
    (target: U, handler: @escaping (U) -> ObserverEventHandler) -> ObserverDisposable
  {
    let subscription = ObserverSubscription(
      target: target, handler: handler, event: self)
    eventHandlers.append(subscription)
    return subscription
  }
}

class ObserverSubscription<T: AnyObject, U> : ObserverInvocable, ObserverDisposable
{
  weak var target: T? // note: weak reference!
  let handler: (T) -> (U) -> ()
  let event: ObserverEvent<U>

  init(target: T?,
       handler: @escaping (T) -> (U) -> (),
       event: ObserverEvent<U>)
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

class ObserverPerson
{
  let fallsIll = ObserverEvent<String>()
  init() {}
  func catchACold()
  {

  }
}

class Demo
{
  init() {
    let p = ObserverPerson()
    let sub = p.fallsIll.addHandler(target: self, handler:Demo.callDoctor)

    // emulate person being ill
    p.fallsIll.raise("123 London Road")

    // no longer interested in the subscription
    sub.dispose()
  }

  func callDoctor(address: String)
  {
    print("We need a doctor at \(address)")
  }
}

func mainObserver()
{
  let _ = Demo()
}

