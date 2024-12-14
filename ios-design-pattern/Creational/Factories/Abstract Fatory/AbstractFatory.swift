//
//  AbstractFatory.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

protocol HotDrink {
    func consume()
}

class Tea: HotDrink {
    func consume() { }
}

class Coffee: HotDrink {
    func consume() { }
}

// Now what we're going to do now is we're going to build a corresponding family of factories

protocol HotDrinkFactory {
    func prepare(amout: Int) -> HotDrink
}

class TeaFactory: HotDrinkFactory {
    func prepare(amout: Int) -> HotDrink {
        return Tea()
    }
}

class CoffeeFactory: HotDrinkFactory {
    func prepare(amout: Int) -> HotDrink {
        return Coffee()
    }
}

/*
 Suppose I walk to the factory, U dont need to tell I need a factory and use this factory to prepare somethings,
 */

class HotDrinkMachine {
    enum AvailableDrink {
        case coffee
        case tea
    }
}

