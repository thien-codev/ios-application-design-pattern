//
//  DynamicDecorator.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 15/12/24.
//


/*
 Suppose that u have a shape and want to add some additional functions
 */

protocol DynamicDecoratorShape {
    init() // requited for construction
}

class DynamicDecoratorCircleShape: DynamicDecoratorShape {
    required init() {
        radius = 0
    }
    
    private var radius: Float
    
    init(radius: Float) {
        self.radius = radius
    }
}

class DynamicDecoratorSquareShape: DynamicDecoratorShape {
    private var side: Float
    required init() {
        side = 0
    }
    init(side: Float) {
        self.side = side
    }
}

// Now i want to enhance this square by give additional functions
// Those below are decorated object
class ColoredShape<T> : DynamicDecoratorShape where T : DynamicDecoratorShape
{
  private var color: String = "black"
  private var shape: T = T()

  required init() {}
  init(_ color: String)
  {
    self.color = color
  }

  public var description: String
  {
    return "has the color \(color)"
  }
}

class TransparentShape<T> : DynamicDecoratorShape where T : DynamicDecoratorShape
{
  private var transparency: Float = 0
  private var shape: T = T()
  
  required init(){}
  init(_ transparency: Float)
  {
    self.transparency = transparency
  }

  public var description: String
  {
    return "has transparency \(transparency*100)%"
  }
}

