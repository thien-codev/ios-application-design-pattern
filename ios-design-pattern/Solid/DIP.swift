//
//  DIP.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Now, the dependency inversion principle specifies two separate things.
 First of all, it specifies that high level modules should not depend on low level modules, but that
 both should depend on abstractions.
 And furthermore, it specifies that abstractions should not depend on details, but details should depend
 on abstractions.
 */

// Simple term?
// So easy to demonstrate

enum Relationship {
    case parent
    case sibling
    case child
}

struct Person {
    var name: String
}

class HomeCreatation {
    var relationships: [Relationships]
    
    init(relationships: [Relationships]) {
        self.relationships = relationships
    }
}

class Relationships {
    var pairMembers: [(Person, Relationship, Person)] = []
    
    func addRelationships(_ r: (Person, Relationship, Person)) {
        pairMembers.append(r)
    }
}

// U dont need pass Relationships to HomeCreatation directly, it's hard to test ..
// Solution

protocol RelationshipsProtocol {
    func addRelationships(_ r: (Person, Relationship, Person))
}

class UpdatedHomeCreatation {
    var relationships: [RelationshipsProtocol]
    
    init(relationships: [RelationshipsProtocol]) {
        self.relationships = relationships
    }
}
// the u can mock the RelationshipsProtocol to test UpdatedHomeCreatation
