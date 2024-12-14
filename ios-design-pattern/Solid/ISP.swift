//
//  ISP.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Suppose u have a document, and u want to operate on it, such as print, scan, modify,..
 -> define interface for these operations
 */

class Document {
    var name: String
    var content: String
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}

protocol Machine {
    func print(doc: Document)
    func scan(doc: Document)
    func modify(doc: Document)
}

class MFP: Machine {
    func print(doc: Document) { }
    func scan(doc: Document) { }
    func modify(doc: Document) { }
}

// The problem -> if client want a machine to print old fasionable doc only
// Go
class OldFasionableMachine: Machine {
    func print(doc: Document) { }
    func scan(doc: Document) { /* do not require */ }
    func modify(doc: Document) { /* do not require */ }
}

// How ??
protocol PrintMachine {
    func print(doc: Document)
}

protocol ScanMachine {
    func scan(doc: Document)
}

protocol ModifyMachine {
    func modify(doc: Document)
}

protocol Photograper: PrintMachine, ScanMachine { }

protocol MultibleOperationMachine: Photograper, ModifyMachine { }
