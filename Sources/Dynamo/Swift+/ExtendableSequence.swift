//
//  ExtendableSequence.swift
//
//  A modification to certain Sequence implementations to support in-place insertion.
//
//  Carson Rau - 3/2/22
//

/// A protocol that describes a sequence to which you can insert or append elements.
///
/// Conforming types specify the types they return from their inserting and appending methods through associated types.
///
/// - Note: The associated types for insert and append methods are defaulted to Void, indicating that by default
/// these methods do not return any value.
public protocol ExtendableSequence: Sequence {
    /// The type of an insterted element.
    associatedtype ElementInsertType = Void
    /// The type of an appended element.
    associatedtype ElementAppendType = Void
    /// The type of a sequence of inserted elements.
    associatedtype ElementsInsertType = Void
    /// The type of a sequence of appended elements.
    associatedtype ElementsAppendType = Void
    /// Inserts a single element into the sequence.
    ///
    /// - Parameter _: The element to insert into the sequence.
    /// - Returns: A value of type ElementInsertType. The return value is discardable.
    @discardableResult
    mutating func insert(_: Element) -> ElementInsertType
    /// Inserts the elements of a sequence into the sequence.
    ///
    /// - Parameter _: The sequence whose elements are to be inserted into the sequence.
    /// - Returns: A value of type ElementsInsertType. The return value is discardable.
    @discardableResult
    mutating func insert<A: Sequence>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Inserts the elements of a collection into the sequence.
    ///
    /// - Parameter _: The collection whose elements are to be inserted into the sequence.
    /// - Returns: A value of type ElementsInsertType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(contentsOf: [4, 5, 6]) // array is now [4, 5, 6, 1, 2, 3]
    /// ```
    @discardableResult
    mutating func insert<A: Collection>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Inserts the elements of a bidirectional collection into the sequence.
    ///
    /// - Parameter _: The bidirectional collection whose elements are to be inserted into the sequence.
    /// - Returns: A value of type ElementsInsertType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(contentsOf: [4, 5, 6]) // array is now [4, 5, 6, 1, 2, 3]
    /// ```
    @discardableResult
    mutating func insert<A: BidirectionalCollection>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Inserts the elements of a random access collection into the sequence.
    ///
    /// - Parameter _: The random access collection whose elements are to be inserted into the sequence.
    /// - Returns: A value of type ElementsInsertType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(contentsOf: [4, 5, 6]) // array is now [4, 5, 6, 1, 2, 3]
    /// ```
    @discardableResult
    mutating func insert<A: RandomAccessCollection>(contentsOf _: A) -> ElementsInsertType where A.Element == Element
    /// Appends a single element to the sequence.
    ///
    /// - Parameter _: The element to append to the sequence.
    /// - Returns: A value of type ElementAppendType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.append(4) // array is now [1, 2, 3, 4]
    /// ```
    @discardableResult
    mutating func append(_: Element) -> ElementAppendType
    /// Appends the elements of a sequence to the sequence.
    ///
    /// - Parameter _: The sequence whose elements are to be appended to the sequence.
    /// - Returns: A value of type ElementsAppendType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.append(contentsOf: [4, 5, 6]) // array is now [1, 2, 3, 4, 5, 6]
    /// ```
    @discardableResult
    mutating func append<A: Sequence>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
    /// Appends the elements of a collection to the sequence.
    ///
    /// - Parameter _: The collection whose elements are to be appended to the sequence.
    /// - Returns: A value of type ElementsAppendType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.append(contentsOf: [4, 5, 6]) // array is now [1, 2, 3, 4, 5, 6]
    /// ```
    @discardableResult
    mutating  func append<A: Collection>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
    /// Appends the elements of a bidirectional collection to the sequence.
    ///
    /// - Parameter _: The bidirectional collection whose elements are to be appended to the sequence.
    /// - Returns: A value of type ElementsAppendType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.append(contentsOf: [4, 5, 6]) // array is now [1, 2, 3, 4, 5, 6]
    /// ```
    @discardableResult
    mutating func append<A: BidirectionalCollection>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
    /// Appends the elements of a random access collection to the sequence.
    ///
    /// - Parameter _: The random access collection whose elements are to be appended to the sequence.
    /// - Returns: A value of type ElementsAppendType. The return value is discardable.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.append(contentsOf: [4, 5, 6]) // array is now [1, 2, 3, 4, 5, 6]
    /// ```
    @discardableResult
    mutating func append<A: RandomAccessCollection>(contentsOf _: A) -> ElementsAppendType where A.Element == Element
}

/// A protocol that describes a collection to which you can insert or append elements.
///
/// It combines the requirements of the `ExtendableSequence` and `Collection` protocols.
public protocol ExtendableCollection: Collection, ExtendableSequence { }

/// A protocol that describes a range-replaceable collection to which you can insert or append elements.
///
/// It combines the requirements of the `ExtendableCollection` and `RangeReplaceableCollection` protocols.
public protocol ExtendableRangeReplaceableCollection: ExtendableCollection, RangeReplaceableCollection { }

// MARK: - Implementation

extension ExtendableSequence where ElementsAppendType == Void {
    /// Appends the elements of a sequence to the sequence, using the append method for individual elements.
    ///
    /// - Parameter newElements: The sequence whose elements are to be appended to the sequence.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.append(contentsOf: [4, 5, 6]) // array is now [1, 2, 3, 4, 5, 6]
    /// ```
    public mutating func append<A: Sequence>(contentsOf newElements: A) where A.Element == Element {
        newElements.forEach { self.append($0) }
    }
}
extension ExtendableSequence where ElementsInsertType == Void {
    /// Inserts the elements of a sequence into the sequence when `ElementsInsertType` is `Void`.
    ///
    /// This method enumerates over `newElements` in reverse order and calls `insert` for each element.
    /// It is meant for types conforming to `ExtendableSequence` where `ElementsInsertType` is `Void`.
    ///
    /// - Parameter newElements: The sequence whose elements are to be inserted into the sequence.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(contentsOf: [4, 5, 6]) // array is now [6, 5, 4, 1, 2, 3]
    /// ```
    public mutating func insert<A: Sequence>(contentsOf newElements: A) where A.Element == Element {
        newElements.reversed().forEach { self.insert($0) }
    }
    /// Inserts the elements of a collection into the sequence when `ElementsInsertType` is `Void`.
    ///
    /// This method enumerates over `newElements` in reverse order and calls `insert` for each element.
    /// It is meant for types conforming to `ExtendableSequence` where `ElementsInsertType` is `Void`.
    ///
    /// - Parameter newElements: The collection whose elements are to be inserted into the sequence.
    ///
    /// # Example
    /// 
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(contentsOf: [4, 5, 6]) // array is now [6, 5, 4, 1, 2, 3]
    /// ```
    public mutating func insert<A: Collection>(contentsOf newElements: A) where A.Element == Element {
        newElements.reversed().forEach { self.insert($0) }
    }
    /// Inserts the elements of a collection into the sequence when `ElementsInsertType` is `Void` and
    /// `A.Index: Strideable`.
    ///
    /// This method enumerates over `newElements` in reverse order and calls `insert`
    /// for each element.
    /// It is meant for types conforming to `ExtendableSequence` where `ElementsInsertType` is `Void`
    /// and the collection's index type conforms to `Strideable`.
    ///
    /// - Parameter newElements: The collection whose elements are to be inserted into the sequence.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(contentsOf: [4, 5, 6]) // array is now [6, 5, 4, 1, 2, 3]
    /// ```
    public mutating func insert<A: Collection>(contentsOf newElements: A)
    where A.Element == Element, A.Index: Strideable {
        newElements.reversed().forEach { self.insert($0) }
    }
}
extension ExtendableRangeReplaceableCollection where ElementInsertType == Void {
    /// Inserts a new element at the start of the collection when `ElementInsertType` is `Void`.
    ///
    /// This method is meant for types conforming to `ExtendableRangeReplaceableCollection` where
    /// `ElementInsertType` is `Void`.
    ///
    /// - Parameter newElement: The element to be inserted at the start of the collection.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array: [Int] = [1, 2, 3]
    /// array.insert(0) // array is now [0, 1, 2, 3]
    /// ```
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: startIndex)
    }
}
// MARK: - Extensions
extension ExtendableSequence {
    /// Returns a copy of the sequence with a new element inserted.
    ///
    /// - Parameter newElement: The element to insert into the sequence.
    /// - Returns: A copy of the sequence with the new element inserted.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array: [Int] = [1, 2, 3]
    /// let newArray = array.inserting(0) // newArray is [0, 1, 2, 3]
    /// ```
    public func inserting(_ newElement: Element) -> Self {
        self |> { $0.insert(newElement) }
    }
    /// Returns a copy of the sequence with the elements of another sequence inserted.
    ///
    /// - Parameter newElements: The sequence whose elements are to be inserted into the sequence.
    /// - Returns: A copy of the sequence with the elements of the other sequence inserted.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array: [Int] = [1, 2, 3]
    /// let newArray = array.inserting(contentsOf: [4, 5, 6]) // newArray is [6, 5, 4, 1, 2, 3]
    /// ```
    public func inserting<A: Sequence>(contentsOf newElements: A) -> Self where A.Element == Element {
        self |> { $0.insert(contentsOf: newElements) }
    }
    /// Returns a copy of the sequence with a new element appended.
     ///
     /// - Parameter newElement: The element to append to the sequence.
     /// - Returns: A copy of the sequence with the new element appended.
     ///
     /// # Example
    ///
     /// ```swift
     /// let array: [Int] = [1, 2, 3]
     /// let newArray = array.appending(4) // newArray is [1, 2, 3, 4]
     /// ```
    public func appending(_ newElement: Element) -> Self {
        self |> { $0.append(newElement) }
    }
    /// Returns a copy of the sequence with the elements of another sequence appended.
    ///
    /// - Parameter newElements: The sequence whose elements are to be appended to the sequence.
    /// - Returns: A copy of the sequence with the elements of the other sequence appended.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array: [Int] = [1, 2, 3]
    /// let newArray = array.appending(contentsOf: [4, 5, 6]) // newArray is [1, 2, 3, 4, 5, 6]
    /// ```
    public func appending<A: Sequence>(contentsOf newElements: A) -> Self where A.Element == Element {
        self |> { $0.append(contentsOf: newElements) }
    }
}
// MARK: - Operators
extension ExtendableSequence {
    /// Concatenates a sequence and a single element, by inserting the element to the start of the sequence.
    ///
    /// - Parameters:
    ///   - lhs: The element to insert at the start of the sequence.
    ///   - rhs: The sequence.
    /// - Returns: A new sequence with `lhs` inserted at the start.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array = 0 + [1, 2, 3]
    /// print(array) // Prints "[0, 1, 2, 3]"
    /// ```
    public static func + (lhs: Element, rhs: Self) -> Self {
        rhs.inserting(lhs)
    }
    /// Concatenates a sequence and a single element, by appending the element to the end of the sequence.
    ///
    /// - Parameters:
    ///   - lhs: The sequence.
    ///   - rhs: The element to append at the end of the sequence.
    /// - Returns: A new sequence with `rhs` appended at the end.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array = [1, 2, 3] + 4
    /// print(array) // Prints "[1, 2, 3, 4]"
    /// ```
    public static func + (lhs: Self, rhs: Element) -> Self {
        lhs.appending(rhs)
    }
    /// Appends a single element to the sequence.
    ///
    /// - Parameters:
    ///   - lhs: The sequence.
    ///   - rhs: The element to append at the end of the sequence.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array = [1, 2, 3]
    /// array += 4
    /// print(array) // Prints "[1, 2, 3, 4]"
    /// ```
    public static func += (lhs: inout Self, rhs: Element) {
        lhs.append(rhs)
    }
    /// Concatenates two sequences, by appending the elements of the second sequence to the end of the first sequence.
    ///
    /// - Parameters:
    ///   - lhs: The first sequence.
    ///   - rhs: The second sequence, whose elements are appended to the end of the first sequence.
    /// - Returns: A new sequence containing the concatenated sequences.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array1 = [1, 2, 3]
    /// let array2 = [4, 5, 6]
    /// let result = array1 + array2
    /// print(result) // Prints "[1, 2, 3, 4, 5, 6]"
    /// ```
    public static func + <A: ExtendableSequence>(lhs: Self, rhs: A) -> Self where A.Element == Element {
        lhs.appending(contentsOf: rhs)
    }
    /// Appends the elements of a sequence to the sequence.
    ///
    /// - Parameters:
    ///   - lhs: The sequence.
    ///   - rhs: The sequence whose elements are appended to the sequence.
    ///
    /// # Example
    /// ```
    /// var array1 = [1, 2, 3]
    /// let array2 = [4, 5, 6]
    /// array1 += array2
    /// print(array1) // Prints "[1, 2, 3, 4, 5, 6]"
    /// ```
    public static func += <A: ExtendableSequence>(lhs: inout Self, rhs: A) where A.Element == Element {
        lhs.append(contentsOf: rhs)
    }
}
extension ExtendableRangeReplaceableCollection {
    /// Concatenates a collection and a single element, by inserting the element to the start of the collection.
    ///
    /// - Parameters:
    ///   - lhs: The element to insert at the start of the collection.
    ///   - rhs: The collection.
    /// - Returns: A new collection with `lhs` inserted at the start.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array = 0 + [1, 2, 3]
    /// print(array) // Prints "[0, 1, 2, 3]"
    /// ```
    public static func + (lhs: Element, rhs: Self) -> Self {
        rhs.inserting(lhs)
    }
    /// Concatenates a collection and a single element, by appending the element to the end of the collection.
    ///
    /// - Parameters:
    ///   - lhs: The collection.
    ///   - rhs: The element to append at the end of the collection.
    /// - Returns: A new collection with `rhs` appended at the end.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array = [1, 2, 3] + 4
    /// print(array) // Prints "[1, 2, 3, 4]"
    /// ```
    public static func + (lhs: Self, rhs: Element) -> Self {
        lhs.appending(rhs)
    }
    /// Appends a single element to the collection.
    ///
    /// - Parameters:
    ///   - lhs: The collection.
    ///   - rhs: The element to append at the end of the collection.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array = [1, 2, 3]
    /// array += 4
    /// print(array) // Prints "[1, 2, 3, 4]"
    /// ```
    public static func += (lhs: inout Self, rhs: Element) {
        lhs.append(rhs)
    }
    /// Concatenates a sequence and a collection, by inserting the elements of the sequence to
    /// the start of the collection.
    ///
    /// - Parameters:
    ///   - lhs: The sequence whose elements are inserted at the start of the collection.
    ///   - rhs: The collection.
    /// - Returns: A new collection containing the elements of `lhs` followed by the elements of `rhs`.
    ///
    /// # Example
    ///
    /// ```swift
    /// let sequence = [0, -1, -2]
    /// let array = sequence + [1, 2, 3]
    /// print(array) // Prints "[-2, -1, 0, 1, 2, 3]"
    /// ```
    public static func + <A: Sequence>(lhs: A, rhs: Self) -> Self where A.Element == Element {
        rhs.inserting(contentsOf: lhs)
    }
    /// Concatenates a collection and a sequence, by appending the elements of the sequence
    /// to the end of the collection.
    ///
    /// - Parameters:
    ///   - lhs: The collection.
    ///   - rhs: The sequence whose elements are appended to the end of the collection.
    /// - Returns: A new collection containing the elements of `lhs` followed by the elements of `rhs`.
    ///
    /// # Example
    ///
    /// ```swift
    /// let array = [1, 2, 3] + [4, 5, 6]
    /// print(array) // Prints "[1, 2, 3, 4, 5, 6]"
    /// ```
    public static func + <A: Sequence>(lhs: Self, rhs: A) -> Self where A.Element == Element {
        lhs.appending(contentsOf: rhs)
    }
    /// Appends the elements of a sequence to the collection.
    ///
    /// - Parameters:
    ///   - lhs: The collection.
    ///   - rhs: The sequence whose elements are appended to the end of the collection.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array = [1, 2, 3]
    /// array += [4, 5, 6]
    /// print(array) // Prints "[1, 2, 3, 4, 5, 6]"
    /// ```
    public static func += <A: Sequence>(lhs: inout Self, rhs: A) where A.Element == Element {
        lhs.append(contentsOf: rhs)
    }
    /// Concatenates two collections.
    ///
    /// - Parameters:
    ///   - lhs: The first collection.
    ///   - rhs: The second collection, whose elements are appended to the end of the first collection.
    /// - Returns: A new collection containing the elements of `lhs` followed by the elements of `rhs`.
    ///
    /// # Example
    ///
    /// ```swift
    /// let firstArray = [1, 2, 3]
    /// let secondArray = [4, 5, 6]
    /// let newArray = firstArray + secondArray
    /// print(newArray) // Prints "[1, 2, 3, 4, 5, 6]"
    /// ```
    public static func + <A: ExtendableRangeReplaceableCollection>(lhs: Self, rhs: A) -> Self
    where A.Element == Element {
        lhs.appending(contentsOf: rhs)
    }
    /// Appends the elements of another collection to the collection.
    ///
    /// - Parameters:
    ///   - lhs: The first collection.
    ///   - rhs: The second collection, whose elements are appended to the end of the first collection.
    ///
    /// # Example
    ///
    /// ```swift
    /// var firstArray = [1, 2, 3]
    /// let secondArray = [4, 5, 6]
    /// firstArray += secondArray
    /// print(firstArray) // Prints "[1, 2, 3, 4, 5, 6]"
    /// ```
    public static func += <A: ExtendableRangeReplaceableCollection>(lhs: inout Self, rhs: A)
    where A.Element == Element {
        lhs.append(contentsOf: rhs)
    }
}

// MARK: - Protocol Conformances

extension Array: ExtendableSequence {
    /// Inserts a new element at the beginning of the array.
    ///
    /// - Parameters:
    ///   - newElement: The new element to insert into the array.
    ///
    /// # Example
    ///
    /// ```swift
    /// var array = [1, 2, 3]
    /// array.insert(0)
    /// print(array) // Prints "[0, 1, 2, 3]"
    /// ```
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: 0)
    }
}
extension Dictionary: ExtendableSequence {
    /// Inserts a new key-value pair into the dictionary.
    ///
    /// - Parameters:
    ///   - newElement: The key-value pair to insert into the dictionary.
    ///
    /// # Example
    ///
    /// ```swift
    /// var dict = ["one": 1, "two": 2]
    /// dict.insert(("three", 3))
    /// print(dict) // Prints "["one": 1, "two": 2, "three": 3]"
    /// ```
    public mutating func insert(_ newElement: Element) {
        append(newElement)
    }
    /// Appends a new key-value pair to the dictionary. If the key already
    /// exists in the dictionary, its value is updated.
    ///
    /// - Parameters:
    ///   - newElement: The key-value pair to append to the dictionary.
    ///
    /// # Example
    ///
    /// ```swift
    /// var dict = ["one": 1, "two": 2]
    /// dict.append(("two", 3))
    /// print(dict) // Prints "["one": 1, "two": 3]"
    /// ```
    public mutating func append(_ newElement: Element) {
        self[newElement.0] = newElement.1
    }
    /// Appends the elements of a sequence to the dictionary. If a key from the sequence
    /// already exists in the dictionary, its value is updated.
    ///
    /// - Parameters:
    ///   - newElements: The sequence of key-value pairs to append to the dictionary.
    ///
    /// # Example
    ///
    /// ```swift
    /// var dict = ["one": 1, "two": 2]
    /// dict.append(contentsOf: [("three", 3), ("four", 4)])
    /// print(dict) // Prints "["one": 1, "two": 2, "three": 3, "four": 4]"
    /// ```
    public mutating func append <S: Sequence>(contentsOf newElements: S) where S.Element == Element {
        newElements.forEach { self.append($0) }
    }
}
extension String: ExtendableSequence {
    /// Inserts a new character at the beginning of the string.
    ///
    /// - Parameters:
    ///   - newElement: The new character to insert into the string.
    ///
    /// # Example
    ///
    /// ```swift
    /// var str = "ello"
    /// str.insert("H")
    /// print(str) // Prints "Hello"
    /// ```
    public mutating func insert(_ newElement: Element) {
        insert(newElement, at: startIndex)
    }
}
extension Set: ExtendableSequence {
    /// Inserts a new element into the set. If the element is already present in the set, this operation has no effect.
    ///
    /// - Parameters:
    ///   - newElement: The new element to insert into the set.
    ///
    /// # Example
    ///
    /// ```swift
    /// var set: Set = [1, 2, 3]
    /// set.append(4)
    /// print(set) // Prints "[1, 2, 3, 4]"
    /// ```
    public mutating func append(_ newElement: Element) {
        insert(newElement)
    }
}
extension String.UnicodeScalarView: ExtendableRangeReplaceableCollection { }
