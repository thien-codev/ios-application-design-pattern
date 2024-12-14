//
//  Prototype.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Suppose that u have the exist object (a large object) which u want to make the diference one and want to copy that exist object
    - U have to clone it and customize it
        * deep clone support
 
 Prototype is basically initialized object that u clone and use it
 
 */

class Address: Copying, Cloning {
    
    var street: String
    var city: String
    
    required init(from another: Address) {
        self.street = another.street
        self.city = another.city
    }
    
    init(street: String, city: String) {
        self.street = street
        self.city = city
    }
    
    func clone() -> Self {
        return Address(street: street, city: city) as! Self
    }
}

class Employee: Copying, Cloning {

    var name: String
    var address: Address
    
    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
    
    required init(from another: Employee) {
        self.name = another.name
        self.address = Address(from: another.address)
    }
    
    func clone() -> Self {
        return Employee(name: name, address: address) as! Self
    }
}

protocol Copying {
    init(from another: Self)
}


// How about "DEEP" copy

protocol Cloning {
    func clone() -> Self
}
// work fine with struct but a little bit nasty with class


/*
 SUMMARY:
 So to implement a prototype, you take a partially or fully constructed object, and first of all,
 you store it somewhere, so you keep it somewhere for replication.
 And then whenever somebody asks you for it, you basically clone the prototype.
 */
