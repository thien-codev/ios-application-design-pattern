//
//  Composite.swift
//  ios-design-pattern
//
//  Created by Nguyen Thien on 14/12/24.
//

/*
 Composite pattern
    - Object use other object's properties/func through inhertitance and composition
    -  composition allows us to make compound objects.
 
 
 In below example: GraphicObject use CompositeCircle via enheritance(CompositeCircle : GraphicObject)
 */

class GraphicObject : CustomStringConvertible
{
  var name: String = "Group"
  var color: String = ""

  var children = [GraphicObject]()

  init()
  {

  }

  init(name: String)
  {
    self.name = name
  }

  private func print(buffer: inout String, depth: Int)
  {
    buffer.append(String(repeating: "*", count: depth))
    buffer.append(color.isEmpty ? "" : "\(color) ")
    buffer.append("\(name)\n")

    for child in children
    {
      child.print(buffer: &buffer, depth: depth+1)
    }
  }

  var description: String
  {
    var buffer = ""
    print(buffer: &buffer, depth: 0)
    return buffer
  }
}

class CompositeCircle : GraphicObject
{
  init(color: String)
  {
    super.init(name: "Circle")
    self.color = color
  }
}

class CompositeSquare : GraphicObject
{
  init(color: String)
  {
    super.init(name: "Square")
    self.color = color
  }
}

func mainC()
{
  let drawing = GraphicObject(name: "My Drawing")
  drawing.children.append(CompositeSquare(color: "Red"))
  drawing.children.append(CompositeCircle(color: "Yellow"))

  let group = GraphicObject()
  group.children.append(CompositeCircle(color: "Blue"))
  group.children.append(CompositeSquare(color: "Blue"))

  drawing.children.append(group)

  print(drawing.description)
}



/// Another example
class Neuron : Sequence
{
  var inputs = [Neuron]()
  var outputs = [Neuron]()

  func makeIterator() -> IndexingIterator<Array<Neuron>>
  {
    return IndexingIterator(_elements: [self])
  }

  func connectTo(_ other: Neuron)
  {
    outputs.append(other)
    other.inputs.append(self)
  }
}

class NeuronLayer : Sequence
{
  private var neurons: [Neuron]

  init(count: Int)
  {
    neurons = [Neuron](repeating: Neuron(), count: count)
  }

  func makeIterator() -> IndexingIterator<Array<Neuron>>
  {
    return IndexingIterator(_elements: neurons)
  }
}

extension Sequence
{
  func connectTo<Seq: Sequence>(_ other: Seq)
    where Seq.Iterator.Element == Neuron,
    Self.Iterator.Element == Neuron
  {
    for from in self
    {
      for to in other
      {
        from.outputs.append(to)
        to.inputs.append(from)
      }
    }
  }
}

func mainD()
{
  let neuron1 = Neuron()
  let neuron2 = Neuron()
  let layer1 = NeuronLayer(count: 10)
  let layer2 = NeuronLayer(count: 20)

  neuron1.connectTo(neuron2)
  neuron1.connectTo(layer1)
  layer2.connectTo(neuron1)
  layer1.connectTo(layer2)
}
