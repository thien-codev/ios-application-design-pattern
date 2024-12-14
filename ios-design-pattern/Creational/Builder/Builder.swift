//
//  Builder.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Reason:
 - init func with a ton of arguments is not productive
 -> build an object step-by-step
 
 Fluent builder ?? -> U can build like this
 Builder()
    .addName()
    .addAge()
    .addInfo()
 */


class HtmlElement : CustomStringConvertible {
  var name = ""
  var text = ""
  var elements = [HtmlElement]()
  private let indentSize = 2


  init() {}
  init(name: String, text: String) {
    self.name = name
    self.text = text
  }

  private func description(_ indent:Int) -> String {
    var result = ""
    let i = String(repeating: " ", count: indent)
    result += "\(i)<\(name)>\n"

    if (!text.isEmpty) {
      result += String(repeating: " ",
        count: indentSize * (indent + 1))
      result += text
      result += "\n"
    }

    for e in elements {
      result += e.description(indent+1)
    }

    result += "\(i)</\(name)>\n"

    return result
  }

  public var description: String {
    return description(0)
  }
}

class HtmlBuilder : CustomStringConvertible {
  private let rootName: String
  var root = HtmlElement()

  init(rootName: String) {
    self.rootName = rootName
    root.name = rootName
  }

  // not fluent
  func addChild(name: String, text: String) {
    let e = HtmlElement(name:name, text:text)
    root.elements.append(e)
  }

  func addChildFluent(childName: String, childText: String) -> HtmlBuilder {
    let e = HtmlElement(name:childName, text:childText)
    root.elements.append(e)
    return self
  }

  public var description: String {
    return root.description
  }

  func clear() {
    root = HtmlElement(name: rootName, text: "")
  }
}

// Faceted builder
/*
 We can understand easily that build group of argument in separated builder
 */
class PersonA: CustomStringConvertible {
  // address
  var streetAddress = "", postcode = "", city = ""

  // employment
  var companyName = "", position = ""
  var annualIncome = 0

  var description: String {
    return "I live at \(streetAddress), \(postcode), \(city). " +
      "I work at \(companyName) as a \(position) earning \(annualIncome)."
  }
}

class PersonBuilder {
  var person = PersonA()
  var lives : PersonAddressBuilder {
    return PersonAddressBuilder(person)
  }
  var works : PersonJobBuilder {
    return PersonJobBuilder(person)
  }

  // no implicit conversions, so...
  func build() -> PersonA
  {
    return person
  }
}

class PersonJobBuilder : PersonBuilder
{
  internal init(_ person: PersonA)
  {
    super.init()
    self.person = person
  }
  func at(_ companyName: String) -> PersonJobBuilder
  {
    person.companyName = companyName
    return self
  }
  func asA(_ position: String) -> PersonJobBuilder
  {
    person.position = position
    return self
  }
  func earning(_ annualIncome: Int) -> PersonJobBuilder
  {
    person.annualIncome = annualIncome
    return self
  }
}

class PersonAddressBuilder: PersonBuilder
{
  internal init(_ person: PersonA)
  {
    super.init()
    self.person = person
  }
  func at(_ streetAddress: String) -> PersonAddressBuilder
  {
    person.streetAddress = streetAddress
    return self
  }
  func withPostcode(_ postcode: String) -> PersonAddressBuilder
  {
    person.postcode = postcode
    return self
  }
  func inCity(_ city: String) -> PersonAddressBuilder
  {
    person.city = city
    return self
  }
}

// Sumary
/*
 Builder:
    - the builder is a separate component which is used for building up an object.
    - you can either give the builder itself an initializer to begin with, or you can return the builder
    - you can also make a FLUENT builder to make the initialization even more succinct. -> return self
    - FACETED builder -> group of small builder
 */
