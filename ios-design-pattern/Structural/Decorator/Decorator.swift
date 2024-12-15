//
//  Decorator.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 it's the idea of adding behavior
 to the class without really altering the class itself or without necessarily using inheritance.
 
 REASON:
    - We want to modify a object with additional functions
    - Do not want to rewrite or alter the exist code OCP
    - Keep new functionality separate SRP
    => 2 options:
        1. Inherite from required object, some objects are final
        2. Build a Decorator, and provide additional behavious
 
 
 * Scenarior: suppose that u want a component which contruct piece of code
 */

class CodeBuilder {
    private var buffer: String = ""
    
    init(buffer: String) {
        self.buffer = buffer
    }
    
    // Now the Decorator
    func append(_ s: String) -> CodeBuilder {
        buffer.append(s)
        return self
    }
    
    func appendLine(_ s: String) -> CodeBuilder {
        buffer.append("\(s)\n")
        return self
    }
}

/*
 cd = CodeBuilder()
 cd.appendLine("thien").append("hello")
 */

// The most common situation when u want to apply Decorator when you feel a desire for implementing multiple inheritance.

protocol Flyable {
    func fly()
}

protocol Crawlable {
    func crawl()
}
class Bird {
    func fly() {
        
    }
}

class Lizard {
    func crawl() {
        
    }
}

class Dragon: Flyable, Crawlable {
    func crawl() {
        
    }
    
    func fly() {
        
    }
}
