//
//  FactoryMethod.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Reason:
    - Well, typically, object creation logic is easy, but sometimes it becomes a bit too complicated.
    - Initializer is not descriptive
        * name is just "init"
    - Object can be outsourced from somewhere
 => Solution:
    - Factory method: one very obvious approach is just to have a separate function, possibly a Static function.
    - you might decide to make a separate class which takes care of initialization, of creation, of different objects
 
 -> Separation of concern, regarding SRP of Solid
 */

import Foundation

class Point {
    var x, y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(rho: Double, theta: Double) {
        self.x = rho * sin(theta)
        self.y = rho * cos(theta)
    }
    
    // Factory method
    static func createCartesian(x: Double, y: Double) -> Point {
        return Point(x: x, y: y)
    }
    
    static func createPolar(rho: Double, theta: Double) -> Point {
        return Point(rho: rho, theta: theta)
    }
}

// And the problem with Initializers is the name that you use for calling.
// => This is where FACTORY METHOD come into play
/*
 This is simply a STATIC method which is used to construct object
 */
