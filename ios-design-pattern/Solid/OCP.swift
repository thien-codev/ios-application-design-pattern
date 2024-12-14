//
//  OCP.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

import Foundation

struct Product {
    let name: String
    let color: String
    let size: String
    
    init(name: String, color: String, size: String) {
        self.name = name
        self.color = color
        self.size = size
    }
}

class ProductFilter {
    /*
     And the problem with this is that every time somebody wants an extension of the functionality, you
     have to go back into a class that you've already written, a class that you've already tested, and
     you have to make modifications to it.
     */
    func filterByColor(_ products: [Product], _ color: String) -> [Product] {
        // implementation
        return products.filter({ $0.color == color })
    }
    
    func filterBySizeAndColor(_ products: [Product], _ size: String, _ color: String) -> [Product] {
        // implementation
        return products.filter({ $0.size == size && $0.color == color })
    }
    
    /*
     => OCP: the class should be open for extension and closed for the modification
     => Solution...
     */
}

// ...=> Solution
// The chalenge: How to filter by Color and Size reguarding OCP???
// ColorAndSizeSpec

protocol Specification {
    associatedtype Item
    func isSastisfied(_ item: Item) -> Bool
}

protocol FilterProtocol {
    associatedtype Item
    func filter<Spec: Specification>(_ spec: Spec, _ items: [Item]) -> [Item] where Item == Spec.Item
}

class BetterProductFilter: FilterProtocol {
    
    typealias Item = Product
    
    func filter<Spec: Specification>(_ spec: Spec, _ items: [Product]) -> [Product] where Spec.Item == Item {
        return items.filter({ spec.isSastisfied($0) })
    }
}

class ColorSpec: Specification {
    
    typealias Item = Product
    let color: String
    
    init(color: String) {
        self.color = color
    }
    
    func isSastisfied(_ item: Product) -> Bool {
        return item.color == color
    }
}


class SizeSpec: Specification {
    
    typealias Item = Product
    let size: String
    
    init(size: String) {
        self.size = size
    }
    
    func isSastisfied(_ item: Product) -> Bool {
        return item.size == size
    }
}

// nice but need better
class ColorAndSizeSpec: Specification {
    
    typealias Item = Product
    let color: String
    let size: String
    
    init(color: String, size: String) {
        self.color = color
        self.size = size
    }
    
    func isSastisfied(_ item: Product) -> Bool {
        return item.color == color && item.size == size
    }
}

class AndSpecification<T, SpecA: Specification, SpecB: Specification> : Specification where T == SpecA.Item, T == SpecB.Item {
    
    let specA: SpecA
    let specB: SpecB
    
    init(specA: SpecA, specB: SpecB) {
        self.specA = specA
        self.specB = specB
    }
    
    typealias Item = T
    
    func isSastisfied(_ item: T) -> Bool {
        return specA.isSastisfied(item) && specB.isSastisfied(item)
    }
}

func mainCOP() {
    let apple = Product(name: "Apple", color: "green", size: "small")
    let tree = Product(name: "Tree", color: "green", size: "small")
    let house = Product(name: "Apple", color: "blue", size: "big")
    
    let products = [apple, tree, house]
    
    let pf = ProductFilter()
    print(pf.filterByColor(products, "green"))
    
    // ...=> Solution
    let betterFilter = BetterProductFilter()
    print(betterFilter.filter(ColorSpec(color: "green"), products))
    
    // filter by color and size
    print(betterFilter.filter(ColorAndSizeSpec(color: "green", size: "small"), products))
    
    // the best
    print(betterFilter.filter(AndSpecification(specA: ColorSpec(color: "green"), specB: SizeSpec(size: "small")), products))
}

