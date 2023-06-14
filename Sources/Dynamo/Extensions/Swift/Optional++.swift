//
//  Optional+.swift
//
//  Extensions to the Swift Optional type.
//
//  Carson Rau - 1/31/22
//

@usableFromInline
internal enum _OptionalError: Error { case unwrap }

extension Optional {
    /// Creates an optional based on a condition.
    ///
    /// - Parameters:
    ///     - wrapped: The value to wrap in an Optional.
    ///     - condition: The condition to check. If the condition is true, the value is wrapped in an Optional,
    ///     otherwise returns nil.
    ///
    /// - Returns: The value wrapped in an Optional if the condition is true, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `wrapped` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt = Optional(5, if: true) // returns Optional(5)
    /// let nilOptional = Optional(5, if: false) // returns nil
    /// ```
    @inlinable
    public init(_ wrapped: @autoclosure () throws -> Wrapped, if condition: Bool) rethrows {
        self = condition ? try wrapped() : nil
    }
    /// Creates an optional based on a condition.
    ///
    /// - Parameters:
    ///     - wrapped: The Optional value to wrap in an Optional.
    ///     - condition: The condition to check. If the condition is true, the value is wrapped in an Optional,
    ///     otherwise returns nil.
    ///
    /// - Returns: The Optional value wrapped in an Optional if the condition is true, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `wrapped` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt = Optional(Optional(5), if: true) // returns Optional(Optional(5))
    /// let nilOptional = Optional(Optional(5), if: false) // returns nil
    /// ```
    @inlinable
    public init(_ wrapped: @autoclosure () throws -> Wrapped?, if condition: Bool) rethrows {
        self = condition ? try wrapped() : nil
    }
}

extension Optional {
    /// Compacts an optional of optionals into a single layer of optionality.
    ///
    /// - Returns: The value wrapped in an Optional if it exists, nil otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let doubleOptional: Int?? = 5
    /// let singleOptional = doubleOptional.compact() // returns Optional(5)
    /// ```
    public func compact<T>() -> T? where Wrapped == T? { self ?? .none }
    /// Compacts an optional of optionals into a single layer of optionality.
    ///
    /// - Returns: The value wrapped in an Optional if it exists, nil otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let tripleOptional: Int??? = 5
    /// let singleOptional = tripleOptional.compact() // returns Optional(5)
    /// ```
    public func compact<T>() -> T? where Wrapped == T?? { (self ?? .none) ?? .none }
    /// Compacts an optional of optionals into a single layer of optionality.
    ///
    /// - Returns: The value wrapped in an Optional if it exists, nil otherwise.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let quadOptional: Int???? = 5
    /// let singleOptional = quadOptional.compact() // returns Optional(5)
    /// ```
    public func compact<T>() -> T? where Wrapped == T??? { ((self ?? .none) ?? .none) ?? .none }
    /// Filters the Optional's wrapped value with a predicate.
    ///
    /// - Parameters:
    ///     - predicate: A closure that takes the unwrapped value as its argument and returns a Boolean value
    ///     indicating whether to keep the value.
    ///
    /// - Returns: The unwrapped value if it satisfies the predicate, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `predicate` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let filtered = optionalInt.filter { $0 > 3 } // returns Optional(5)
    /// ```
    @inlinable
    public func filter(_  predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        try map(predicate) == .some(true) ? self : .none
    }
    /// Returns the wrapped value of the Optional if it exists, otherwise runs the predicate closure and returns
    /// its result.
    ///
    /// - Parameters:
    ///     - predicate: A closure that returns a wrapped value of the Optional.
    ///
    /// - Returns: The wrapped value of the Optional if it exists, otherwise the result of the predicate closure.
    ///
    /// - Throws: Any error thrown by the `predicate` closure.
    ///
    /// # Usage:
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let result = optionalInt.flatMapNil { 5 } // returns Optional(5)
    /// ```
    @inlinable
    public func flatMapNil(_ predicate: () throws -> Wrapped?) rethrows -> Wrapped? {
        try self ?? predicate()
    }
    /// Checks if the Optional contains a value.
    ///
    /// - Returns: A Boolean value indicating whether the Optional contains a value.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let hasValue = optionalInt.isSome // returns true
    /// ```
    @inlinable public var isSome: Bool { self != nil }
    /// Checks if the Optional is empty.
    ///
    /// - Returns: A Boolean value indicating whether the Optional is nil.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let isEmpty = optionalInt.isNone // returns true
    /// ```
    @inlinable public var isNone: Bool { self == nil }
    /// Unwraps the Optional and updates the input variable with the unwrapped value if it exists.
    ///
    /// - Parameters:
    ///     - wrapped: The variable to update with the unwrapped value.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// var intValue = 0
    /// let optionalInt: Int? = 5
    /// optionalInt.map(into: &intValue) // intValue is now 5
    /// ```
    @inlinable
    public func map(into wrapped: inout Wrapped) { map { wrapped = $0 } }
    /// Unwraps the Optional if it exists, otherwise runs the predicate closure and returns its result.
    ///
    /// - Parameters:
    ///     - predicate: A closure that returns a wrapped value of the Optional.
    ///
    /// - Returns: The unwrapped value of the Optional if it exists, otherwise the result of the predicate closure.
    ///
    /// - Throws: Any error thrown by the `predicate` closure.
    ///
    /// # Usage:
    /// 
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let result = optionalInt.mapNil { 5 } // returns Optional(5)
    /// ```
    @inlinable
    public func mapNil(_ predicate: () throws -> Wrapped) rethrows -> Wrapped? {
        try self ?? .some(try predicate())
    }
    /// Maps the wrapped value of the Optional using the function provided or returns a default value.
    ///
    /// - Parameters:
    ///     - defaultValue: The value to return if the Optional is empty.
    ///     - fn: A closure that takes the unwrapped value and returns a value of type T.
    ///
    /// - Returns: The result of mapping the wrapped value using the function provided or the default value.
    ///
    /// - Throws: Any error thrown by the `fn` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let result = optionalInt.maybe(0) { $0 * 2 } // returns 10
    /// ```
    @inlinable
    public func maybe<T>(_ defaultValue: T, fn: (Wrapped) throws -> T) rethrows -> T {
        try map(fn) ?? defaultValue
    }
    // swiftlint:disable force_unwrapping self_binding
    /// Applies a mutating operation to the wrapped value.
    ///
    /// - Parameters:
    ///     - transform: A closure that takes the wrapped value as inout and returns a value of type T.
    ///
    /// - Returns: The result of applying the transformation if the Optional contains a value, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `transform` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// var optionalInt: Int? = 5
    /// optionalInt.mutate { $0 += 3 } // optionalInt is now 8
    /// ```
    @inlinable
    public mutating func mutate<T>(_ transform: (inout Wrapped) throws -> T) rethrows -> T? {
        guard self != nil else { return nil }
        return try transform(&self!)
    }
    /// Calls the specified function if the Optional is empty, then returns the Optional.
    ///
    /// - Parameters:
    ///     - fn: A closure to execute if the Optional is empty.
    ///
    /// - Returns: The Optional.
    ///
    /// - Throws: Any error thrown by the `fn` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let result = optionalInt.onNone { print("Optional is empty") } // prints "Optional is empty" and returns nil
    /// ```
    @discardableResult
    @inlinable
    public func onNone(_ fn: () throws -> Void) rethrows -> Wrapped? {
        if isNone { try fn() }
        return self
    }
    /// Calls the specified function with the unwrapped value if the Optional contains a value,
    /// then returns the Optional.
    ///
    /// - Parameters:
    ///     - fn: A closure to execute with the unwrapped value.
    ///
    /// - Returns: The Optional.
    ///
    /// - Throws: Any error thrown by the `fn` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let result = optionalInt.onSome { print($0) } // prints "5" and returns Optional(5)
    /// ```
    @discardableResult
    @inlinable
    public func onSome(_ fn: (Wrapped) throws -> Void) rethrows -> Wrapped? {
        if let wrapped = self { try fn(wrapped) }
        return self
    }
    /// Unwraps the Optional, forcing a runtime error if the Optional is empty.
    ///
    /// - Parameters:
    ///     - message: A closure that produces an error message in case of runtime error.
    ///
    /// - Returns: The unwrapped value of the Optional.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let unwrapped = optionalInt.orFatallyThrow("Unexpected nil") // returns 5
    /// ```
    @inlinable
    public func orFatallyThrow(_ message: @autoclosure () -> String) -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            fatalError(message())
        }
    }
    /// Unwraps the Optional or throws an error if the Optional is empty.
    ///
    /// - Returns: The unwrapped value of the Optional.
    ///
    /// - Throws: `_OptionalError.unwrap` if the Optional is empty.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let unwrapped = try? optionalInt.unwrap() // returns Optional(5)
    /// ```
    @inlinable
    public func unwrap() throws -> Wrapped {
        guard let wrapped = self else { throw _OptionalError.unwrap }
        return wrapped
    }
    /// Unwraps the Optional or throws a specified error if the Optional is empty.
    ///
    /// - Parameters:
    ///     - error: A closure that produces an error if the Optional is empty.
    ///
    /// - Returns: The unwrapped value of the Optional.
    ///
    /// - Throws: The error produced by the `error` closure if the Optional is empty.
    ///
    /// #Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let unwrapped = try? optionalInt.unwrapOrThrow(MyError.someError) // throws MyError.someError
    /// ```
    @inlinable
    public func unwrapOrThrow(_ error: @autoclosure () throws -> Error) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw try error()
        }
    }
    /// Unwraps the Optional and removes the wrapped value.
    ///
    /// - Returns: The unwrapped value of the Optional.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// var optionalInt: Int? = 5
    /// let removed = optionalInt.remove() // returns 5 and optionalInt is now nil
    /// ```
    @inlinable
    public mutating func remove() -> Wrapped {
        defer { self = nil }
        return self!
    }
    // swiftlint:enable self_binding force_unwrapping
    /// Unwraps the Optional, forcing a runtime error if the Optional is empty.
    ///
    /// - Returns: The unwrapped value of the Optional.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let unwrapped = optionalInt.forceUnwrap() // returns 5
    /// ```
    @inlinable
    public func forceUnwrap() -> Wrapped {
        // swiftlint:disable force_try
        try! unwrap()
        // swiftlint:enable force_try
    }
}
// MARK: - Conditional Conformance
extension Optional where Wrapped: Collection {
    /// A Boolean value indicating whether the collection is nil or empty.
    ///
    /// When you need to check whether your collection is nil or empty, use the `isNilOrEmpty` property instead of
    /// checking the `count` property to be zero. Unlike `isEmpty`, `isNilOrEmpty` also checks for `nil`.
    ///
    /// - Returns: `true` if the collection is nil or empty; otherwise, `false`.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// var items: [Int]? = []
    /// print(items.isNilOrEmpty) // Prints "true"
    /// items = [10, 20, 30]
    /// print(items.isNilOrEmpty) // Prints "false"
    /// ```
    public var isNilOrEmpty: Bool { map { $0.isEmpty } ?? true }
}

extension Optional where Wrapped: SignedInteger {
    /// A value correcting negative integers to `nil`.
    ///
    /// If the integer is negative, the property converts the integer to `nil`.
    ///
    /// - Returns: The original integer if it's zero or positive; otherwise, `nil`.
    ///
    /// # Usage:
    /// 
    /// ```swift
    /// var number: Int? = -10
    /// print(number.nilIfBelowZero) // Prints "nil"
    /// number = 10
    /// print(number.nilIfBelowZero) // Prints "Optional(10)"
    /// ```
    public var nilIfBelowZero: Wrapped? {
        let correctedValue: Wrapped?
        switch self {
        case .none:
            correctedValue = nil
        case .some(let value):
            correctedValue = value >= 0 ? value : nil
        }
        return correctedValue
    }
}
// MARK: - Operators
extension Optional {
    /// Executes the right-hand side closure if the Optional is non-nil.
    ///
    /// - Parameters:
    ///     - rhs: A closure that produces a value if the Optional is non-nil.
    ///
    /// - Returns: The value produced by the `rhs` closure if the Optional is non-nil, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `rhs` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let result = optionalInt &&-> { 10 } // returns Optional(10)
    /// ```
    public static func &&-> <A>(lhs: Self, rhs: @autoclosure () throws -> A) rethrows -> A? {
        if lhs.isNone { return nil }
        return try rhs()
    }
    /// Executes the right-hand side closure if the Optional is non-nil.
    ///
    /// - Parameters:
    ///     - rhs: A closure that produces an Optional if the Optional is non-nil.
    ///
    /// - Returns: The Optional produced by the `rhs` closure if the Optional is non-nil, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `rhs` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = 5
    /// let result = optionalInt &&-> { Optional(10) } // returns Optional(10)
    /// ```
    public static func &&-> <A>(lhs: Self, rhs: @autoclosure () throws -> A?) rethrows -> A? {
        if lhs.isNone { return nil }
        return try rhs()
    }
    /// Executes the right-hand side closure if the Optional is nil.
    ///
    /// - Parameters:
    ///     - rhs: A closure that produces a value if the Optional is nil.
    ///
    /// - Returns: The value produced by the `rhs` closure if the Optional is nil, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `rhs` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let result = optionalInt ||-> { 10 } // returns Optional(10)
    /// ```
    public static func ||-> <A>(lhs: Self, rhs: @autoclosure () throws -> A) rethrows -> A? {
        if lhs.isSome { return nil }
        return try rhs()
    }
    /// Executes the right-hand side closure if the Optional is nil.
    ///
    /// - Parameters:
    ///     - rhs: A closure that produces an Optional if the Optional is nil.
    ///
    /// - Returns: The Optional produced by the `rhs` closure if the Optional is nil, nil otherwise.
    ///
    /// - Throws: Any error thrown by the `rhs` closure.
    ///
    /// # Usage:
    ///
    /// ```swift
    /// let optionalInt: Int? = nil
    /// let result = optionalInt ||-> { Optional(10) } // returns Optional(10)
    /// ```
    public static func ||-> <A>(lhs: Self, rhs: @autoclosure () throws -> A?) rethrows -> A? {
        if lhs.isSome { return nil }
        return try rhs()
    }
}
