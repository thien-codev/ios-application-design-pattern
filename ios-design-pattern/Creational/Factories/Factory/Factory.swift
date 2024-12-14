//
//  Factory.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 15/12/24.
//

/*
 You want to actually have a separate component which takes care of the construction of that object, and
 that is typically called a factory.
 */

class PointFactory {
    static func createCartesian(x: Double, y: Double) -> Point {
        return Point(x: x, y: y)
    }
    
    static func createPolar(rho: Double, theta: Double) -> Point {
        return Point(rho: rho, theta: theta)
    }
}
