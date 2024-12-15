//
//  Bridge.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 BRIDGE
 Connecting components together through abstraction
 Example:
    - U have ThreadScheduler
    - Can run on Unix or Windows
 
 
"a bridge is a mechanism that
decouples the interface or the hierarchy from the implementation."
 */

protocol Renderer {
    func renderCircle(_ radius: Float)
}

class VectorRender: Renderer {
    func renderCircle(_ radius: Float) { }
}

class RasterRender: Renderer {
    func renderCircle(_ radius: Float) { }
}

protocol Shape {
    func draw()
}

// Like Circle dont need to decide how to draw, it depend on the render
class Circle: Shape {
    
    var radius: Float
    // Bridge part
    var render: Renderer
    
    init(radius: Float, render: Renderer) {
        self.radius = radius
        self.render = render
    }
    
    func draw() {
        render.renderCircle(radius)
    }
}

class Rectangle: Shape {
    func draw() { }
}
