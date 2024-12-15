//
//  Facade.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 The idea of Exposing several components through a single easy to use
 Interface.
 
 
 "The facade design pattern provides a simple and easy to understand API over a large and sophisticated
 body of code that may involve"
 */

/*
 The idea:
    - Hide the body
    - expose the interface
 */

class Buffer {
    var width, height: Int
    var buffer: [Character]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.buffer = [Character](repeating: " ", count: width * height)
    }
    
    subscript(_ index: Int) -> Character {
        return buffer[index]
    }
}

class Viewport {
    var buffer: Buffer
    var offset = 0
    init(buffer: Buffer, offset: Int = 0) {
        self.buffer = buffer
        self.offset = offset
    }
    
    func getChar(_ idx: Int) -> Character {
        return buffer[offset+idx]
    }
}
// Now build the Facade
// U do not work with Viewport,and Buffer directly, u only work with Console
class Console {
    var buffers: [Buffer] = []
    var viewports: [Viewport] = []
    var offset = 0
    
    init() {
        let b = Buffer(width: 30, height: 20)
        let v = Viewport(buffer: b)
        buffers.append(b)
        viewports.append(v)
    }
    
    func getChar(_ idx: Int) -> Character {
        return viewports[0].getChar(idx)
    }
}


/*
 
 SUMMARY:
    - Build a Facade to provide the specific API over a set of classes
 */
