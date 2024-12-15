//
//  Proxy.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 15/12/24.
//

/*
 
 REASON:
 a proxy is a class which functions as an interface to a particular resource.
And that resource can be remote, It can be expensive to construct or it may require logging or some
other added functionality.
 */

// Let talk about Proxy protection

import Foundation

protocol Vehicle {
    func drive()
}

class Car: Vehicle {
    func drive() {}
}

class Driver {
    var age: Int
    
    init(age: Int) {
        self.age = age
    }
}

class CarProxy: Vehicle {
    private var car = Car()
    private var driver: Driver
    
    init(car: Car = Car(), driver: Driver) {
        self.car = car
        self.driver = driver
    }
    
    func drive() {
        if driver.age > 25 {
            // can drive
        } else {
            // too young to drive
        }
    }
}

// Let talk about Property Proxy
class Property<T: Equatable>
{
  private var _value: T

  public var value: T {
    get {
      return _value
    }
    set(value) {
      if (value == _value) {
        return
      }
      print("Setting value to \(value)")
      _value = value
    }
  }

  init(_ value: T)
  {
    self._value = value
  }
}

extension Property: Equatable {}

// compare the values of two properties
func ==<T>(lhs: Property<T>, rhs: Property<T>) -> Bool
{
  return lhs.value == rhs.value
}

class Creature
{
  // start with public
  private let _agility = Property<Int>(0)

  // no implicit conversions, so...
  var agility: Int {
    get { return _agility.value }
    set(value) { _agility.value = value }
  }
}

func mainG()
{
  let c = Creature()
  c.agility = 10

  print(c.agility)
}


/*
 QUESTION: Compare Proxy vs Decorator
 */
