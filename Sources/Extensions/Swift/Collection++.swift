//
//  Collection+.swift
//
//
//  Created by Carson Rau on 1/31/22
//

extension Collection {
    /// Access the bounds of this collection as a range.
    @inlinable public var bounds: Range<Index> { startIndex ..< endIndex }
    /// Map each index to its distance from the first index in the collection.
    @inlinable public var distances: LazyMapCollection<Indices, Int> {
        indices.lazy.map(distanceFromStartIndex)
    }
    @inlinable public var fullRange: Range<Index> { startIndex ..< endIndex }
    @inlinable public var lastIndex: Index { indices.last.forceUnwrap() }
    /// The length of the collection.
    @inlinable public var length: Int { distance(from: startIndex, to: endIndex) }
}

extension Collection {
    public func consecutives() -> AnySequence<(Element, Element)> {
        guard !isEmpty else { return .init([]) }
        func makeIterator() -> AnyIterator<(Element, Element)> {
            var idx = startIndex
            return AnyIterator {
                let nextIdx = self.index(after: idx)
                guard nextIdx < self.endIndex else { return nil }
                defer { idx = nextIdx }
                return (self[idx], self[nextIdx])
            }
        }
        return .init(makeIterator)
    }
    @inlinable
    public func containsIndex(_ index: Index) -> Bool {
        index >= startIndex && index < endIndex
    }
    @inlinable
    public func contains(after index: Index) -> Bool {
        containsIndex(index) && containsIndex(self.index(after: index))
    }
    @inlinable
    public func contains(_ bounds: Range<Index>) -> Bool {
        containsIndex(bounds.lowerBound) && containsIndex(index(bounds.upperBound, offsetBy: -1))
    }
    @inlinable
    public func distanceFromStartIndex(to index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
    @inlinable
    public func enumerated() -> LazyMapCollection<Self.Indices, (Self.Index, Self.Element)> {
        indices.lazy.map { ($0, self[$0]) }
    }
    @inlinable
    public func index(of predicate: (Element) throws -> Bool) rethrows -> Index? {
        try enumerated().find { try predicate($1) }?.0
    }
    @inlinable
    public func index(atDistance distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    @inlinable
    public func index(_ index: Index, insetBy distance: Int) -> Index {
        self.index(index, offsetBy: -distance)
    }
    @inlinable
    public func index(_ index: Index, offsetByDistanceFromStartIndexFor otherIndex: Index) -> Index {
        self.index(index, offsetBy: distanceFromStartIndex(to: otherIndex))
    }
    @inlinable
    public func range(from range: Range<Int>) -> Range<Index> {
        index(atDistance: range.lowerBound) ..< index(atDistance: range.upperBound)
    }
    @inlinable
    public func randomElements(count: Int) -> ArraySlice<Element> { shuffled().prefix(count) }
}

extension Collection {
    public subscript(atDistance distance: Int) -> Element {
        @inlinable get { self[index(atDistance: distance)] }
    }
    public subscript(betweenDistances distance: Range<Int>) -> SubSequence {
        @inlinable get {
            self[index(atDistance: distance.lowerBound) ..< index(atDistance: distance.upperBound)]
        }
    }
    public subscript(betweenDistances distance: ClosedRange<Int>) -> SubSequence {
        @inlinable get {
            self[index(atDistance: distance.lowerBound)...index(atDistance: distance.upperBound)]
        }
    }
    public subscript(after index: Index) -> Element {
        self[self.index(after: index)]
    }
    public subscript(try index: Index) -> Element? {
        @inlinable get { Optional(self[index], if: containsIndex(index)) }
    }
    public subscript(try bounds: Range<Index>) -> SubSequence? {
        @inlinable get { Optional(self[bounds], if: contains(bounds)) }
    }
}

// MARK: - Conditional Conformances

extension Collection where Index: Strideable {
    @inlinable public var stride: Index.Stride {
        startIndex.distance(to: endIndex)
    }
}
