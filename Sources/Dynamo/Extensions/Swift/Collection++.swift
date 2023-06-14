//
//  Collection+.swift
//
//
//  Created by Carson Rau on 1/31/22
//

extension Collection {
    /// Returns the range of valid indices for the collection.
    ///
    /// - Returns: The range from the start to the end index of the collection.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.bounds)  // prints "0..<5"
    /// ```
    @inlinable public var bounds: Range<Index> { startIndex ..< endIndex }
    /// Maps each index to its distance from the start index.
    ///
    /// - Returns: A lazy map collection where each index is mapped to its distance from the start index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = ["a", "b", "c", "d", "e"]
    /// print(array.distances)  // prints "[0, 1, 2, 3, 4]"
    /// ```
    @inlinable public var distances: LazyMapCollection<Indices, Int> {
        indices.lazy.map(distanceFromStartIndex)
    }
    /// Returns the full range of valid indices for the collection.
    ///
    /// - Returns: The range from the start to the end index of the collection.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.fullRange)  // prints "0..<5"
    /// ```
    @inlinable public var fullRange: Range<Index> { startIndex ..< endIndex }
    /// Returns the last index of the collection.
    ///
    /// - Returns: The last index of the collection. Force unwraps the `last` property of `indices`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.lastIndex)  // prints "4"
    /// ```
    @inlinable public var lastIndex: Index { indices.last.forceUnwrap() }
    /// Returns the number of elements in the collection.
    ///
    /// - Returns: The distance from the start index to the end index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.length)  // prints "5"
    /// ```
    @inlinable public var length: Int { distance(from: startIndex, to: endIndex) }
}

extension Collection {
    /// Returns a sequence of consecutive elements in the collection.
    ///
    /// - Returns: A sequence of tuples, where each tuple contains two consecutive elements from the collection.
    ///            Returns an empty sequence if the collection is empty.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// for pair in array.consecutives() {
    ///     print(pair)
    /// }
    /// // prints "(1, 2)"
    /// // prints "(2, 3)"
    /// // prints "(3, 4)"
    /// // prints "(4, 5)"
    /// ```
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
    /// Checks if the collection contains the given index.
    ///
    /// - Parameter index: The index to check.
    /// - Returns: `true` if the index is within the collection's bounds, `false` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.containsIndex(3))  // prints "true"
    /// print(array.containsIndex(10)) // prints "false"
    /// ```
    @inlinable
    public func containsIndex(_ index: Index) -> Bool {
        index >= startIndex && index < endIndex
    }
    /// Checks if the collection contains an index after the given index.
    ///
    /// - Parameter index: The index to check after.
    /// - Returns: `true` if there is an index after the given index within the collection's bounds, `false` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.contains(after: 3))  // prints "true"
    /// print(array.contains(after: 4)) // prints "false"
    /// ```
    @inlinable
    public func contains(after index: Index) -> Bool {
        containsIndex(index) && containsIndex(self.index(after: index))
    }
    /// Checks if the collection contains the given range of indices.
    ///
    /// - Parameter bounds: The range of indices to check.
    /// - Returns: `true` if the range is within the collection's bounds, `false` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.contains(1..<3))  // prints "true"
    /// print(array.contains(4..<10)) // prints "false"
    /// ```
    @inlinable
    public func contains(_ bounds: Range<Index>) -> Bool {
        containsIndex(bounds.lowerBound) && containsIndex(index(bounds.upperBound, offsetBy: -1))
    }
    /// Returns the distance from the start index to the given index.
    ///
    /// - Parameter index: The index to measure the distance to.
    /// - Returns: The distance from the start index to the given index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.distanceFromStartIndex(to: 3))  // prints "3"
    /// ```
    @inlinable
    public func distanceFromStartIndex(to index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
    /// Returns a lazy map collection that pairs each index with its corresponding element.
    ///
    /// - Returns: A lazy map collection where each index is paired with its corresponding element.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = ["a", "b", "c", "d", "e"]
    /// for (index, element) in array.enumerated() {
    ///     print("\(index): \(element)")
    /// }
    /// // prints "0: a"
    /// // prints "1: b"
    /// // prints "2: c"
    /// // prints "3: d"
    /// // prints "4: e"
    /// ```
    @inlinable
    public func enumerated() -> LazyMapCollection<Self.Indices, (Self.Index, Self.Element)> {
        indices.lazy.map { ($0, self[$0]) }
    }
    /// Returns the index of the first element for which the given predicate returns `true`.
    ///
    /// - Parameter predicate: A closure that takes an element and returns a `Bool`.
    /// - Returns: The index of the first element for which `predicate` returns `true`, or `nil`
    /// if such an element does not exist.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.index(of: { $0 > 3 }))  // prints "Optional(3)"
    /// ```
    @inlinable
    public func index(of predicate: (Element) throws -> Bool) rethrows -> Index? {
        try enumerated().find { try predicate($1) }?.0
    }
    /// Returns an index that is the specified distance from the start index.
    ///
    /// - Parameter distance: The distance to offset from the start index.
    /// - Returns: An index that is `distance` positions from the start index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.index(atDistance: 3))  // prints "3"
    /// ```
    @inlinable
    public func index(atDistance distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    /// Returns an index that is the specified distance before the given index.
    ///
    /// - Parameters:
    ///   - index: The index to offset from.
    ///   - distance: The distance to offset.
    /// - Returns: An index that is `distance` positions before the given index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.index(3, insetBy: 1))  // prints "2"
    /// ```
    @inlinable
    public func index(_ index: Index, insetBy distance: Int) -> Index {
        self.index(index, offsetBy: -distance)
    }
    /// Returns an index that is the distance from the start index to another index, offset from a given index.
    ///
    /// - Parameters:
    ///   - index: The index to offset from.
    ///   - otherIndex: The index to measure the distance to the start index.
    /// - Returns: An index that is the distance from the start index to `otherIndex`, offset from `index`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.index(2, offsetByDistanceFromStartIndexFor: 3))  // prints "3"
    /// ```
    @inlinable
    public func index(_ index: Index, offsetByDistanceFromStartIndexFor otherIndex: Index) -> Index {
        self.index(index, offsetBy: distanceFromStartIndex(to: otherIndex))
    }
    /// Returns a range of indices that corresponds to the given range of Ints.
    ///
    /// - Parameter range: The range of Ints.
    /// - Returns: A range of indices that corresponds to the given range of Ints.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.range(from: 1..<3))  // prints "1..<3"
    /// ```
    @inlinable
    public func range(from range: Range<Int>) -> Range<Index> {
        index(atDistance: range.lowerBound) ..< index(atDistance: range.upperBound)
    }
    /// Returns a random slice of the collection, with the specified number of elements.
    ///
    /// - Parameter count: The number of elements to include in the slice.
    /// - Returns: A slice of the collection, consisting of `count` elements picked randomly, or less if the collection
    /// contains fewer than `count` elements.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.randomElements(count: 3))  // prints "[5, 1, 3]" (example output)
    /// ```
    @inlinable
    public func randomElements(count: Int) -> ArraySlice<Element> { shuffled().prefix(count) }
}

extension Collection {
    /// Accesses the element at the specified distance from the start index.
    ///
    /// - Parameter distance: The distance to the element to access.
    /// - Returns: The element at the specified distance from the start index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[atDistance: 2])  // prints "3"
    /// ```
    public subscript(atDistance distance: Int) -> Element {
        @inlinable get { self[index(atDistance: distance)] }
    }
    /// Accesses a slice of the collection, at the specified range of distances from the start index.
    ///
    /// - Parameter distance: The range of distances to the slice to access.
    /// - Returns: The slice at the specified range of distances from the start index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[betweenDistances: 1..<3])  // prints "[2, 3]"
    /// ```
    public subscript(betweenDistances distance: Range<Int>) -> SubSequence {
        @inlinable get {
            self[index(atDistance: distance.lowerBound) ..< index(atDistance: distance.upperBound)]
        }
    }
    /// Accesses a slice of the collection, at the specified closed range of distances from the start index.
    ///
    /// - Parameter distance: The closed range of distances to the slice to access.
    /// - Returns: The slice at the specified closed range of distances from the start index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[betweenDistances: 1...3])  // prints "[2, 3, 4]"
    /// ```
    public subscript(betweenDistances distance: ClosedRange<Int>) -> SubSequence {
        @inlinable get {
            self[index(atDistance: distance.lowerBound)...index(atDistance: distance.upperBound)]
        }
    }
    /// Accesses the element after the specified index.
    ///
    /// - Parameter index: The index before the element to access.
    /// - Returns: The element after the specified index.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[after: 2])  // prints "4"
    /// ```
    public subscript(after index: Index) -> Element {
        self[self.index(after: index)]
    }
    /// Accesses the element at the specified index, if it is within the bounds of the collection.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index, if it is within the bounds of the collection, or `nil` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[try: 2])  // prints "Optional(3)"
    /// print(array[try: 10]) // prints "nil"
    /// ```
    public subscript(try index: Index) -> Element? {
        @inlinable get { Optional(self[index], if: containsIndex(index)) }
    }
    /// Accesses a slice of the collection, at the specified range of indices, if it is within the bounds
    /// of the collection.
    ///
    /// - Parameter bounds: The range of indices of the slice to access.
    /// - Returns: The slice at the specified range of indices, if it is within the bounds of the collection,
    /// or `nil` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array[try: 1..<3])  // prints "Optional([2, 3])"
    /// print(array[try: 4..<10]) // prints "nil"
    /// ```
    public subscript(try bounds: Range<Index>) -> SubSequence? {
        @inlinable get { Optional(self[bounds], if: contains(bounds)) }
    }
}

// MARK: - Conditional Conformances

extension Collection where Index: Strideable {
    /// Returns the stride (distance) between the start and end indices of the collection.
    ///
    /// - Returns: The stride (distance) between the start and end indices of the collection.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// print(array.stride)  // prints "5"
    /// ```
    @inlinable public var stride: Index.Stride {
        startIndex.distance(to: endIndex)
    }
}
