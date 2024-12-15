//
//  ChainOfResponsibility.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Situation:
 Think about a situation where you have unethical behavior by an employee of the company.
 
 
 Another example: Let's suppose you have some collectible card game and you have lots of creatures with attack and defense
 values and these defense and attack values.
 They can be affected by other cards.
 And so you have this chain of responsibility where one card can actually be boosted by other cards.
 */

class ChainOfResCreature {
    var name: String
    var attack: Int
    var defense: Int
    
    init(name: String, attack: Int, defense: Int) {
        self.name = name
        self.attack = attack
        self.defense = defense
    }
}

class CreatureModifier {
    let creature: ChainOfResCreature
    var next: CreatureModifier?
    
    init(creature: ChainOfResCreature) {
        self.creature = creature
    }
    
    func add(_ cm: CreatureModifier) {
        if next != nil {
            next?.add(cm)
        } else {
            next = cm
        }
    }
    
    func handle() {
        next?.handle() // chain
    }
}

class DoubleAttackModifier: CreatureModifier {
    override func handle() {
        creature.attack *= 2
        super.handle()
    }
}

class IncreaseDefenceModifier: CreatureModifier {
    override func handle() {
        creature.defense += 3
        super.handle()
    }
}
