//
//  Adapter.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 An adapter is a construct which adapts an existing interface X to conform to the required
 
 The whole point of having the adapter pattern is that you can adapt one interface to another interface.
 */

class AdapterPoint : CustomStringConvertible, Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    public var description: String {
        return "X = \(x), Y = \(y)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    static func ==(lhs: AdapterPoint, rhs: AdapterPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class AdapterLine: Hashable {
    var start: AdapterPoint
    var end: AdapterPoint
    
    init(_ start: AdapterPoint, _ end: AdapterPoint) {
        self.start = start
        self.end = end
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(end)
    }
    static func ==(lhs: AdapterLine, rhs: AdapterLine) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

class VectorObject : Sequence {
    var lines = [AdapterLine]()
    
    func makeIterator() -> IndexingIterator<Array<AdapterLine>> {
        return IndexingIterator(_elements: lines)
    }
}

class VectorRectangle : VectorObject {
    init(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
        super.init()
        lines.append(AdapterLine(AdapterPoint(x,y), AdapterPoint(x+width, y)))
        lines.append(AdapterLine(AdapterPoint(x+width, y), AdapterPoint(x+width, y+height)))
        lines.append(AdapterLine(AdapterPoint(x,y), AdapterPoint(x,y+height)))
        lines.append(AdapterLine(AdapterPoint(x,y+height), AdapterPoint(x+width, y+height)))
    }
}


// The problem is we want to draw vector but we have the API for draw point -> adapter
// Mock: API drawing point only
func drawPoint(_ p: AdapterPoint) {
    print(".", terminator: "")
}


class LineToPointAdapter : Sequence {
    private static var count = 0
    var points = [AdapterPoint]()
    
    init(_ line: AdapterLine) {
        type(of: self).count += 1
        print("\(type(of: self).count): Generating points for line ",
              "[\(line.start.x),\(line.start.y)]-[\(line.end.x),\(line.end.y)]")
        
        let left = Swift.min(line.start.x, line.end.x)
        let right = Swift.max(line.start.x, line.end.x)
        let top = Swift.min(line.start.y, line.end.y)
        let bottom = Swift.max(line.start.y, line.end.y)
        let dx = right - left
        let dy = line.end.y - line.start.y
        
        if dx == 0 {
            for y in top...bottom {
                points.append(AdapterPoint(left, y))
            }
        } else if dy == 0 {
            for x in left...right {
                points.append(AdapterPoint(x,top))
            }
        }
    }
    
    func makeIterator() -> IndexingIterator<Array<AdapterPoint>> {
        return IndexingIterator(_elements: points)
    }
}


let vectorObjects = [
    VectorRectangle(1,1,10,10),
    VectorRectangle(3,3,6,6)
]

func draw() {
    // unfortunately, can only draw points
    for vo in vectorObjects {
        for line in vo {
            let adapter = LineToPointAdapter(line)
            adapter.forEach{ drawPoint($0) }
        }
    }
}

func mainA() {
    draw()
    draw() // shows why we need caching
}

// But we got problem -> generate too much data from Line to Point
// Solution: hashable and caching


/*
 SUMMARY:
    - determine API u have and API u need, then try to each other
 */
