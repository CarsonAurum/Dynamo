//
//  Sequence+.swift
//
//  Extensions to the Swift Sequence type.
//
//  Carson Rau - 3/1/23
//

extension Sequence {
    @inlinable public var first: Element? {
        for element in self { return element }
        return nil
    }
    public func countElements() -> Int {
        var count = 0
        for _ in self { count += 1 }
        return count
    }
}
