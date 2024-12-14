//
//  InnerFactory.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 15/12/24.
//

/*
 Suppose that u want the init func to be PRIVATE
 */

import Foundation

class AnotherPoint {
    
    private var x, y: Double
    
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    private init(rho: Double, theta: Double) {
        self.x = rho * sin(theta)
        self.y = rho * cos(theta)
    }
    
    static var factory = PointInnerFactory()
    
    class PointInnerFactory {
        func createCartesian(x: Double, y: Double) -> Point {
            return Point(x: x, y: y)
        }
        
        func createPolar(rho: Double, theta: Double) -> Point {
            return Point(rho: rho, theta: theta)
        }
    }

}


