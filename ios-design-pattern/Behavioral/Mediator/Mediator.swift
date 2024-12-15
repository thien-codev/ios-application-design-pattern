//
//  Mediator.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//
/*
 REASON:
    - Component may go and out of a system at any time
        - ex: Chat room participants
    - Make not sense for them to have direct ref to another
        - ref can go dead
 
 
 => Solution: have them all refer to some central component that communications
 */

import Foundation

class MediatorPerson
{
  var name: String
  var room: ChatRoom? = nil // not in a room
  private var chatLog = [String]()

  init(_ name: String)
  {
    self.name = name
  }

  func receive(sender: String, message: String)
  {
    let s = "\(sender): `\(message)`"
    print("[\(name)'s chat session] \(s)")
    chatLog.append(s)
  }

  func say(_ message: String)
  {
    room?.broadcast(sender: name, message: message)
  }

  func pm(to target: String, message: String)
  {
    room?.message(sender: name, destination: target, message: message)
  }
}

class ChatRoom
{
  private var people = [MediatorPerson]()

  func broadcast(sender: String, message: String)
  {
    for p in people
    {
      if p.name != sender
      {
        p.receive(sender: sender, message: message)
      }
    }
  }

  func join(_ p: MediatorPerson)
  {
    let joinMsg = "\(p.name) joins the chat"
    broadcast(sender: "room", message: joinMsg)
    p.room = self
    people.append(p)
  }

  func message(sender: String, destination: String, message: String)
  {
    people.first{ $0.name == destination}?.receive(sender: sender, message: message)
  }
}

func mainAAAA()
{
  let room = ChatRoom()

  let john = MediatorPerson("John")
  let jane = MediatorPerson("Jane")

  room.join(john)
  room.join(jane)

  john.say("hi room")
  jane.say("oh, hey john")

  let simon = MediatorPerson("Simon")
  room.join(simon)
  simon.say("hi everyone!")

  jane.pm(to: "Simon", message: "glad you could join us!")
}

/*
 SUMMARY:
 So let's summarize what we've learned about the mediator design pattern.
 So first of all, you make a mediator which will be referenced by every single object, which requires
 it.
 Typically it's in a property, and typically you want to stick the mediator right inside the initializer
 so nobody forgets to initialize their mediator.
 And then what happens is the mediator engages in bidirectional communication with the connected components.
 So on the one hand, the mediator has functions, the components can call, and on the other hand the
 components have functions that the mediator can call so they know about one another.
 And typically in terms of event processing libraries and stream processing libraries like reactive extensions,
 for example, you can leverage these libraries to make the communication between the different components
 a bit easier to implement because we're talking about streams of data going to and from so reactive
 extensions is very useful here.
 */
