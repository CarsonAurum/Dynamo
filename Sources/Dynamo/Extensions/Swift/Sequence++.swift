//
//  Sequence+.swift
//
//  Extensions to the Swift Sequence type.
//
//  Carson Rau - 3/1/23
//

extension Sequence {
    /// Quick access to the first element in the sequence. If no elements are present in the sequence,
    /// this is nil.
    @inlinable public var first: Element? {
        for element in self {
            return element
        }
        return nil
    }
    /// Flag to determine if the sequence contains any values.
    @inlinable public var isEmpty: Bool { first == nil }
    /// Quick access to the last element in the sequence. If no elements are present in the sequence,
    /// this is nil.
    @inlinable public var last: Element? {
        var result: Element?
        for element in self {
            result = element
        }
        return result
    }
    /// Checks if all elements in the sequence satisfy a given predicate.
    /// - Parameter condition: A closure that takes an element of the sequence as its argument and returns
    /// a Boolean value indicating whether the element passes a condition.
    /// - Throws: An error if the `condition` closure throws an error.
    /// - Returns: `true` if all elements in the sequence satisfy the `condition` closure, `false` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let allEven = numbers.all { $0 % 2 == 0 }
    /// // allEven == false
    /// ```
    public func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try !condition($0) }
    }
    /// Returns a sequence by dropping the initial elements and keeping the elements before a certain index.
    /// - Parameters:
    ///   - startIndex: The start index of the subsequence.
    ///   - endIndex: The end index of the subsequence.
    /// - Returns: A subsequence that starts at `startIndex` and ends before `endIndex`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let subsequence = numbers.between(count: 1, and: 3)
    /// // subsequence == [2, 3]
    /// ```
    public func between(
        count startIndex: Int,
        and endIndex: Int
    ) -> PrefixSequence<DropFirstSequence<Self>> {
        dropFirst(startIndex).prefix(endIndex - startIndex)
    }
    /// Counts the number of elements in the sequence.
    /// - Returns: The number of elements in the sequence.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let count = numbers.countElements()
    /// // count == 4
    /// ```
    public func countElements() -> Int {
        var count = 0
        for _ in self {
            count += 1
        }
        return count
    }
    /// Groups the sequence elements into a dictionary based on a given key and filters those
    /// groups which have more than one element.
    ///
    /// The returned dictionary's keys are unique elements from the sequence, and the values are arrays
    /// that contain all elements corresponding to each key.
    /// - Parameter keyPath: A key path to the element's property that determines the grouping of the
    /// sequence into a dictionary.
    /// - Returns: A dictionary that contains groups of elements from the sequence.
    ///
    /// # Usage:
    /// ```swift
    /// let people = ["Anna", "Alex", "Brian", "Jack"]
    /// let duplicates = people.duplicates(groupedBy: \.first)
    /// // duplicates == ["A": ["Anna", "Alex"]]
    /// ```
    public func duplicates<T: Hashable>(groupedBy keyPath: KeyPath<Element, T>) -> [T: [Element]] {
        .init(grouping: self) { $0[keyPath: keyPath] }.filter { $1.count > 1 }
    }
    /// Returns the element at a specified position if it exists.
    /// - Parameter count: The position of the element to return, where `count` is the number of
    /// elements to initially skip.
    /// - Returns: An optional element. If the `count` exceeds the bounds of the sequence, returns `nil`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let thirdElement = numbers.element(atCount: 2)
    /// // thirdElement == 3
    /// ```
    public func element(atCount count: Int) -> Element? {
        dropFirst(count).last
    }
    /// Returns the element at a specified position in reverse if it exists.
    /// - Parameter count: The position of the element to return, where `count` is the
    /// number of elements to initially skip from the end.
    /// - Returns: An optional element. If the `count` exceeds the bounds of the sequence, returns `nil`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let thirdLastElement = numbers.element(atReverseCount: 2)
    /// // thirdLastElement == 2
    /// ```
    public func element(atReverseCount count: Int) -> Element? {
        dropLast(count).last
    }
    /// Returns the element in the sequence that occurs before the first element that satisfies the given predicate.
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument
    /// and returns a Boolean value indicating whether the element is a match.
    /// - Throws: An error if the `predicate` closure throws an error.
    /// - Returns: The element that occurs before the first match of `predicate`. If no elements satisfy
    /// the predicate, returns `nil`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let beforeThree = numbers.element(before: { $0 == 3 })
    /// // beforeThree == 2
    /// ```
    public func element(before predicate: (Element) throws -> Bool) rethrows -> Element? {
        var last: Element?
        for element in self {
            if try predicate(element) {
                return last
            }
            last = element
        }
        return nil
    }
    /// Returns the element in the sequence that occurs after the first element that satisfies the given predicate.
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean
    /// value indicating whether the element is a match.
    /// - Throws: An error if the `predicate` closure throws an error.
    /// - Returns: The element that occurs after the first match of `predicate`. If no elements satisfy the
    /// predicate, returns `nil`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let afterThree = numbers.element(after: { $0 == 3 })
    /// // afterThree == 4
    /// ```
    public func element(after predicate: (Element) throws -> Bool) rethrows -> Element? {
        var returnNext = false
        for element in self {
            if returnNext {
                return element
            }
            if try predicate(element) {
                returnNext = true
            }
        }
        return nil
    }
    /// Returns an array of elements in the sequence that occur between the first element that satisfies the
    /// `firstPredicate` and the element that satisfies the `lastPredicate`.
    /// - Parameters:
    ///   - firstPredicate: A closure that takes an element of the sequence as its argument and returns a
    ///   Boolean value indicating whether the element is a match for the start of the subsequence.
    ///   - lastPredicate: A closure that takes an element of the sequence as its argument and returns a
    ///   Boolean value indicating whether the element is a match for the end of the subsequence.
    /// - Throws: An error if either `firstPredicate` or `lastPredicate` throws an error.
    /// - Returns: An array of elements. If no elements satisfy the predicates, returns an empty array.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let betweenTwoAndFour = numbers.elements(between: { $0 == 2 }, and: { $0 == 4 })
    /// // betweenTwoAndFour == [3]
    /// ```
    public func elements(
            between firstPredicate: (Element) throws -> Bool,
            and lastPredicate: (Element) throws -> Bool
    ) rethrows -> [Element] {
        var first: Element?
        var result: [Element] = []
        for element in self {
            if try firstPredicate(element) && first == nil {
                first = element
            } else if try lastPredicate(element) {
                return result
            } else if first != nil {
                result += element
            }
        }
        return []
    }
    /// Calls a closure with an accumulating value initialized to `nil` and each element of the sequence,
    /// and returns the final value.
    /// - Parameter iterator: A closure that takes a function that updates the accumulating value
    /// and an element of the sequence, and modifies the accumulating value.
    /// - Throws: An error if the `iterator` closure throws an error.
    /// - Returns: The final accumulating value. If the sequence has no elements, returns `nil`.
    ///
    ///     let numbers = [1, 2, 3, 4]
    ///     let foundElement = numbers.find { take, element in
    ///         if element > 2 {
    ///             take(element)
    ///         }
    ///     }
    ///     // foundElement == 3
    @inlinable
    public func find<T, U>(_ iterator: (_ take: (T) -> Void, _ element: Element) throws -> U) rethrows -> T? {
        var result: T?
        var stop = false
        for element in self {
            _ = try iterator({ stop = true; result = $0}, element)
            if stop { break }
        }
        return result
    }
    /// Returns the first element in the sequence that satisfies a given predicate.
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns
    /// a Boolean value indicating whether the element is a match.
    /// - Throws: An error if the `predicate` closure throws an error.
    /// - Returns: The first match of `predicate` if any exists. Otherwise, returns `nil`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let foundElement = numbers.find { $0 > 2 }
    /// // foundElement == 3
    /// ```
    public func find(_ predicate: (Element) throws -> Bool) rethrows -> Element? {
        try find { take, element in try predicate(element) &&-> take(element) }
    }
    /// Returns a dictionary containing groups of elements of the sequence, using a closure to determine the
    /// grouping key.
    /// - Parameter identify: A closure that takes an element of the sequence as its argument and
    /// returns a value that will be used as a key in the resulting dictionary.
    /// - Throws: An error if the `identify` closure throws an error.
    /// - Returns: A dictionary that contains groups of elements of the sequence.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let people = ["Anna", "Alex", "Brian", "Jack"]
    /// let groupedByFirstLetter = people.group { $0.first }
    /// // groupedByFirstLetter == ["A": ["Anna", "Alex"], "B": ["Brian"], "J": ["Jack"]]
    /// ```
    public func group<T: Hashable>(by identify: (Element) throws -> T) rethrows -> [T: [Element]] {
        var result: [T: [Element]] = .init(minimumCapacity: underestimatedCount)
        for element in self {
            result[try identify(element), default: []].append(element)
        }
        return result
    }
    /// Checks if no elements in the sequence satisfy a given predicate.
    /// - Parameter condition: A closure that takes an element of the sequence as its argument and
    /// returns a Boolean value indicating whether the element is a match.
    /// - Throws: An error if the `condition` closure throws an error.
    /// - Returns: `true` if no elements in the sequence satisfy the `condition` closure, `false` otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let noneEven = numbers.none { $0 % 2 == 0 }
    /// // noneEven == false
    /// ```
    public func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try condition($0) }
    }
    /// Returns an array containing, in order, the elements of the sequence that satisfy a given predicate wrapped in an
    /// Optional.
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns
    /// a Boolean value indicating whether the element should be included in the returned array.
    /// - Throws: An error if the `predicate` closure throws an error.
    /// - Returns: An array of the elements that `predicate` allows. If no elements satisfy the predicate,
    /// the method returns an empty array.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers: [Int?] = [1, nil, 3, nil]
    /// let nonNilNumbers = numbers.optionalFilter { $0 > 1 }
    /// // nonNilNumbers == [nil, 3, nil]
    /// ```
    public func optionalFilter<T>(_ predicate: (T) throws -> Bool) rethrows -> [T?] where Element == T? {
        try filter { try $0.map(predicate) ?? true }
    }
    /// Returns an array containing the results of mapping the given closure over the sequence's elements wrapped
    /// in an Optional.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns
    ///  a transformed value of the same or of a different type.
    /// - Throws: An error if the `transform` closure throws an error.
    /// - Returns: An array containing the transformed elements of this sequence.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers: [Int?] = [1, nil, 3, nil]
    /// let optionalDoubled = numbers.optionalMap { $0 * 2 }
    /// // optionalDoubled == [2, nil, 6, nil]
    /// ```
    public func optionalMap<T, U>(_ transform: (T) throws -> U) rethrows -> [U?] where Element == T? {
        try map { try $0.map(transform) }
    }
    /// Returns the result of combining the elements of the sequence using the given closure.
    /// - Parameter combine: A closure that takes two elements of the sequence as its arguments and returns
    /// the result of combining them. The closure is called sequentially with each element of the sequence and the
    /// result of the previous call.
    /// - Returns: The final accumulated value. If the sequence has no elements, returns `nil`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let product = numbers.reduce { $0 * $1 }
    /// // product == 24
    /// ```
    @inlinable
    public func reduce(_ combine: (Element, Element) -> Element) -> Element? {
        // swiftlint:disable implicitly_unwrapped_optional
        var result: Element!
        for element in self {
            guard result != nil else { result = element; continue }
            result = combine(result, element)
        }
        return result
        // swiftlint:enable implicitly_unwrapped_optional
    }
    /// Returns the result of combining the elements of the sequence using the given closure, starting with
    /// the given initial result value.
    /// - Parameters:
    ///   - initial: The initial accumulating value.
    ///   - combine: A closure that takes an accumulating value and an element of the sequence and returns a
    ///   new accumulating value. The closure is called sequentially with each element of the sequence and the result
    ///   of the previous call.
    /// - Throws: An error if the `combine` closure throws an error.
    /// - Returns: The final accumulated value.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let product = numbers.reduce(1) { result in { result * $0 } }
    /// // product == 24
    /// ```
    @inlinable
    public func reduce<T>(_ initial: T, _ combine: (T) throws -> (Element) -> T) rethrows -> T {
        try reduce(initial) { try combine($0)($1) }
    }
    /// Returns the result of combining the elements of the sequence using the given closure, starting with a `nil`
    /// initial value.
    /// - Parameter combine: A closure that takes an optional accumulating value and an element of the sequence and
    /// returns a new accumulating value. The closure is called sequentially with each element of the sequence and
    /// the result of the previous call.
    /// - Throws: An error if the `combine` closure throws an error.
    /// - Returns: The final accumulated value.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let optionalProduct = numbers.reduce(nil) { result, element in result != nil ? result! * element : element }
    /// // optionalProduct == 24
    /// ```
    @inlinable
    public func reduce<T: ExpressibleByNilLiteral>(_ combine: (T) throws -> (Element) -> T) rethrows -> T {
        try reduce(nil) { try combine($0)($1) }
    }
    /// Returns a sequence created by inserting the given element between each element of the sequence.
    /// - Parameter separator: An element to insert between each of the elements of the sequence.
    /// - Returns: A sequence containing the interleaved elements of the sequence and the `separator`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let separated = numbers.separated(by: 0)
    /// // Array(separated) == [1, 0, 2, 0, 3, 0, 4]
    /// ```
    @inlinable
    public func reduce<T: ExpressibleByNilLiteral>(_ combine: (T, Element) throws -> T) rethrows -> T {
        try reduce(nil, combine)
    }
    /// Returns a sequence created by inserting the given element between each element of the sequence.
    /// - Parameter separator: An element to insert between each of the elements of the sequence.
    /// - Returns: A sequence containing the interleaved elements of the sequence and the `separator`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let separated = numbers.separated(by: 0)
    /// // Array(separated) == [1, 0, 2, 0, 3, 0, 4]
    /// ```
    public func separated(by separator: Element) -> AnySequence<Element> {
        guard let first else { return .init(noSequence: ()) }
        return .init(
                CollectionOfOne(first)
                    .join(dropFirst().flatMap {
                            CollectionOfOne(separator).join(CollectionOfOne($0))
                        }
                    )
        )
    }
    /// Returns a sequence sorted using a key path to a specific value and a custom comparison closure.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to a value of the type `Value`.
    ///   - valuesAreInIncreasingOrder: A closure that takes two parameters of the type `Value` and returns
    ///   a `Bool` indicating whether the first value should be ordered before the second value.
    ///
    /// - Throws: An error if the `valuesAreInIncreasingOrder` closure throws an error.
    ///
    /// - Returns: A sequence sorted using the values of the `keyPath` and the `valuesAreInIncreasingOrder` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// struct Person {
    ///     let name: String
    ///     let age: Int
    /// }
    ///
    /// let people = [
    ///     Person(name: "Anna", age: 23),
    ///     Person(name: "Alex", age: 52),
    ///     Person(name: "Brian", age: 31),
    ///     Person(name: "Jack", age: 44)
    /// ]
    /// let sortedPeople = people.sorted(by: \.age) { $0 > $1 }
    /// // sortedPeople == [Person(name: "Alex", age: 52), Person(name: "Jack", age: 44),
    /// // Person(name: "Brian", age: 31), Person(name: "Anna", age: 23)]
    /// ```
    public func sorted<Value>(
        by keyPath: KeyPath<Self.Element, Value>,
        using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool)
        rethrows -> Self {
        try -!>sorted {
            try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    /// Returns a sequence sorted using a key path to a value of a type that conforms to the `Comparable` protocol.
    /// - Parameter keyPath: A key path to a value of a type that conforms to the `Comparable` protocol.
    /// - Returns: A sequence sorted using the values of the `keyPath`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let people = ["Anna", "Alex", "Brian", "Jack"]
    /// let sortedPeople = people.sorted(by: \.count)
    /// // sortedPeople == ["Anna", "Alex", "Jack", "Brian"]
    /// ```
    public func sorted<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value>)
        -> Self {
        self.sorted(by: keyPath, using: <)
    }
    /// Returns a sequence sorted in the same order as another sequence.
    /// - Parameters:
    ///   - otherArray: A sequence that determines the sort order of the sequence.
    ///   - keyPath: A key path to a value that conforms to the `Hashable` protocol.
    /// - Returns: A sequence sorted in the same order as `otherArray`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let people = ["Anna", "Alex", "Brian", "Jack"]
    /// let sortOrder = ["Brian", "Jack", "Anna", "Alex"]
    /// let sortedPeople = people.sorted(like: sortOrder, keyPath: \.self)
    /// // sortedPeople == ["Brian", "Jack", "Anna", "Alex"]
    /// ```
    public func sorted <T: Hashable>(
            like otherArray: [T],
            keyPath: KeyPath<Element, T>
    ) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) {
            $0[$1.element] = $1.offset
        }
        return sorted {
            guard let thisIdx = dict[$0[keyPath: keyPath]] else { return false }
            guard let nextIdx = dict[$1[keyPath: keyPath]] else { return true }
            return thisIdx < nextIdx
        }
    }
    /// Returns a sequence created by pairing each element of the sequence with an element in another sequence.
    /// The two sequences are iterated in parallel; if one sequence is shorter, elements of the resulting sequence
    /// are `nil` for the rest of the elements in the longer sequence.
    /// - Parameter other: A sequence to pair with this sequence.
    /// - Returns: A sequence of pairs.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let letters = ["a", "b", "c", "d"]
    /// let zipped = numbers.zip(letters)
    /// // Array(zipped) == [(1, "a"), (2, "b"), (3, "c"), (4, "d")]
    /// ```
    @inlinable
    public func zip <S: Sequence>(_ other: S) -> Zip2Sequence<Self, S> {
        Swift.zip(self, other)
    }
    /// Returns a sequence containing the elements of the sequence that lie within a given range.
    /// - Parameter range: A range of valid indices for the sequence.
    /// - Returns: A sequence containing the elements of the sequence that lie within `range`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4]
    /// let subset = numbers[between: 1..<3]
    /// // Array(subset) == [2, 3]
    /// ```
    public subscript(between range: Range<Int>) -> PrefixSequence<DropFirstSequence<Self>> {
        between(count: range.lowerBound, and: range.upperBound)
    }
}

extension Sequence where Element: Sendable {
    public func asyncCompactMap<T: Sendable>(
        _ transform: @Sendable @escaping (Element) async -> T?
    ) async -> [T] {
        var values = [T]()
        for element in self {
            guard let value = await transform(element) else {
                continue
            }
            values += value
        }
        return values
    }
    public func asyncCompactMap<T: Sendable>(
        _ transform: @Sendable @escaping (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            guard let value = try await transform(element) else {
                continue
            }
            values += value
        }
        return values
    }
    public func asyncFlatMap<T: Sequence>(
        _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T.Element] where T.Element: Sendable {
        var values = [T.Element]()
        for element in self {
            await values.append(contentsOf: transform(element))
        }
        return values
    }
    public func asyncFlatMap<T: Sequence>(
        _ transform: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T.Element] where T.Element: Sendable {
        var values = [T.Element]()
        for element in self {
            try await values.append(contentsOf: transform(element))
        }
        return values
    }
    /// Run an async closure for each element within the sequence.
    ///
    /// The closure calls will be performed in order, by waiting for each call to complete before
    /// proceeding with the next one. If any of the closure calls throw an error, then the iteration
    /// will be terminated and the error rethrown.
    ///
    /// - Parameter operation: The closure to run for each element.
    public func asyncForEach(
        _ operation: @Sendable @escaping (Element) async -> Void
    ) async {
        for element in self {
            await operation(element)
        }
    }
    /// Run an async throwing closure for each element within the sequence.
    ///
    /// The closure calls will be performed in order, by waiting for each call to complete before
    /// proceeding with the next one. If any of the closure calls throw an error, then the iteration
    /// will be terminated and the error rethrown.
    ///
    /// - Parameter operation: The closure to run for each element.
    /// - Throws: Rethrows any error thrown by the passed closure.
    public func asyncForEach(
        _ operation: @Sendable @escaping (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
    public func asyncMap<T: Sendable>(
        _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T] {
        var values = [T]()
        for element in self {
            await values += transform(element)
        }
        return values
    }
    public func asyncMap<T: Sendable>(
        _ transform: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values += transform(element)
        }
        return values
    }
    public func concurrentCompactMap<T: Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @Sendable @escaping (Element) async -> T?
    ) async -> [T] {
        await withTaskGroup(of: (Int, T?).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let value = await transform(element.1)
                    return (element.0, value)
                }
            }
            var result = [(Int, T)]()
            while let element = await group.next() {
                guard element.1.isSome else { continue }
                result += (element.0, element.1.forceUnwrap())
            }
            await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    public func concurrentCompactMap<T: Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @Sendable @escaping (Element) async throws -> T?
    ) async throws -> [T] {
        try await withThrowingTaskGroup(of: (Int, T?).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let value = try await transform(element.1)
                    return (element.0, value)
                }
            }
            var result = [(Int, T)]()
            while let element = try await group.next() {
                guard element.1.isSome else { continue }
                result += (element.0, element.1.forceUnwrap())
            }
            try await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    public func concurrentFlatMap<T: Sequence>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T.Element] {
        await withTaskGroup(of: (Int, T).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let values = await transform(element.1)
                    return (element.0, values)
                }
            }
            var results = [(Int, T)]()
            while let value = await group.next() {
                results += value
            }
            await group.waitForAll()
            var result = [T.Element]()
            results.sorted { $0.0 < $1.0 }.forEach { result.append(contentsOf: $0.1) }
            return result
        }
    }
    /// Run an async closure for each element within the sequence.
    ///
    /// The closure calls will be performed concurrently, but the call to this function won't return
    /// until all of the closure calls have completed.
    ///
    /// - Parameters:
    ///   - priority: Any specific `TaskPriority` to assign to the async tasks that will perform
    ///   the closure calls. The default is `nil` (meaning that the system picks a priority).
    ///   - operation: The closure to run for each element.
    public func concurrentForEach(
        withPriority priority: TaskPriority? = nil,
        _ operation: @Sendable @escaping (Element) async -> Void
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask(priority: priority) {
                    await operation(element)
                }
                await group.waitForAll()
            }
        }
    }
    /// Run an async throwing closure for each element within the sequence.
    ///
    /// The closure calls will be performed concurrently, but the call to this function won't return
    /// until all of the closure calls have completed.
    ///
    /// - Parameters:
    ///   - priority: Any specific `TaskPriority` to assign to the async tasks that will perform
    ///   the closure calls. The default is `nil` (meaning that the system picks a priority).
    ///   - operation: The closure to run for each element.
    /// - Throws: Rethrows any errors caught during the operation.
    public func concurrentForEach(
        withPriority priority: TaskPriority? = nil,
        _ operation: @Sendable @escaping (Element) async throws -> Void
    ) async rethrows {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask(priority: priority) {
                    try await operation(element)
                }
            }
            try await group.waitForAll()
        }
    }
    public func concurrentMap<T: Sendable>(
        priority: TaskPriority? = nil,
        _ transform: @Sendable @escaping (Element) async -> T
    ) async -> [T] {
        await withTaskGroup(of: (Int, T).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let result = await transform(element.1)
                    return (element.0, result)
                }
            }
            var result = [(Int, T)]()
            while let element = await group.next() {
                result += element
            }
            await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
    public func concurrentMap<T: Sendable>(
        priority: TaskPriority? = nil,
        _ transform: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: (Int, T).self) { group in
            enumerated().forEach { element in
                group.addTask(priority: priority) {
                    let result = try await transform(element.1)
                    return (element.0, result)
                }
            }
            var result = [(Int, T)]()
            while let element = try await group.next() {
                result += element
            }
            try await group.waitForAll()
            return result.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
}

extension Sequence where Element: Equatable {
    public func allElementsAreEqual(to other: Element) -> Bool {
        var iterator = makeIterator()
        while let next = iterator.next() {
            if next != other {
                return false
            }
        }
        return true
    }
    public func allElementsAreEqual() -> Bool {
        var iterator = makeIterator()
        guard let first = iterator.next() else {
            return true
        }
        while let next = iterator.next() {
            if first != next { return false }
        }
        return true
    }
    public func hasPrefix(_ prefix: Element) -> Bool { first == prefix }
    public func hasPrefix(_ prefix: [Element]) -> Bool {
        var iterator = makeIterator()
        var prefixIterator = prefix.makeIterator()
        while let other = prefixIterator.next() {
            if let element = iterator.next() {
                guard element == other else { return false }
            } else {
                return false
            }
        }
        return true
    }
    public func hasSuffix(_ suffix: Element) -> Bool { last == suffix }
    public func hasSuffix(_ suffix: [Element]) -> Bool {
        var result = false
        for (element, other) in suffix.zip(self.suffix(suffix.toAnyCollection().count)) {
            guard element == other else { return false }
            result = true
        }
        return result
    }
}

extension Sequence where Element: Comparable {
    @inlinable public var minimum: Element? { sorted(by: <).first }
    @inlinable public var maximum: Element? { sorted(by: <).last }
}

extension Sequence where Element: Numeric {
    @inlinable
    public func sum() -> Element {
        reduce(into: 0) { $0 += $1 }
    }
}
