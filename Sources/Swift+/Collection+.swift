//
//  Collection+.swift
//  
//
//  Carson Rau - 3/3/22
//

public struct SequenceToCollection<A: Sequence>: RandomAccessCollection {
    public typealias Value = A
    public typealias Element = A.Element
    public typealias Index = Int
    public typealias Indices = CountableRange<Index>
    public typealias Iterator = Value.Iterator
    
    public let value: Value
    public init(_ value: Value) { self.value = value }
    public var startIndex: Index { 0 }
    public var endIndex: Index { self.countElements() }
    public var indices: Indices { .init(bounds: (startIndex, endIndex)) }
    public subscript(index: Index) -> Element {
        value.dropFirst(index).first.forceUnwrap()
    }
    
    public __consuming func makeIterator() -> Iterator {
        value.makeIterator()
    }
}

extension Sequence {
    public func toAnyCollection() -> SequenceToCollection<Self> { .init(self) }
}
