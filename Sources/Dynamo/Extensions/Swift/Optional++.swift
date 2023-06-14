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
    @inlinable public var isSome: Bool { self != nil }
    @inlinable public var isNone: Bool { self == nil }
    @inlinable
    public func map(into wrapped: inout Wrapped) { map { wrapped = $0 } }
    @inlinable
    public func mapNil(_ predicate: () throws -> Wrapped) rethrows -> Wrapped? {
        try self ?? .some(try predicate())
    }
    @inlinable
    public func maybe<T>(_ defaultValue: T, fn: (Wrapped) throws -> T) rethrows -> T {
        try map(fn) ?? defaultValue
    }
    // swiftlint:disable force_unwrapping self_binding
    @inlinable
    public mutating func mutate<T>(_ transform: (inout Wrapped) throws -> T) rethrows -> T? {
        guard self != nil else { return nil }
        return try transform(&self!)
    }
    @discardableResult
    @inlinable
    public func onNone(_ fn: () throws -> Void) rethrows -> Wrapped? {
        if isNone { try fn() }
        return self
    }
    @discardableResult
    @inlinable
    public func onSome(_ fn: (Wrapped) throws -> Void) rethrows -> Wrapped? {
        if let wrapped = self { try fn(wrapped) }
        return self
    }
    @inlinable
    public func orFatallyThrow(_ message: @autoclosure () -> String) -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            fatalError(message())
        }
    }
    @inlinable
    public func unwrap() throws -> Wrapped {
        guard let wrapped = self else { throw _OptionalError.unwrap }
        return wrapped
    }
    @inlinable
    public func unwrapOrThrow(_ error: @autoclosure () throws -> Error) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw try error()
        }
    }
    @inlinable
    public mutating func remove() -> Wrapped {
        defer { self = nil }
        return self!
    }
    // swiftlint:enable self_binding force_unwrapping
}
// MARK: - Conditional Conformance
extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool { map { $0.isEmpty } ?? true }
}

extension Optional where Wrapped: SignedInteger {
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

extension Optional {
    @inlinable
    public func forceUnwrap() -> Wrapped {
        // swiftlint:disable force_try
        try! unwrap()
        // swiftlint:enable force_try
    }
}

// MARK: - Operators
extension Optional {
    public static func &&-> <A>(lhs: Self, rhs: @autoclosure () throws -> A) rethrows -> A? {
        if lhs.isNone { return nil }
        return try rhs()
    }
    public static func &&-> <A>(lhs: Self, rhs: @autoclosure () throws -> A?) rethrows -> A? {
        if lhs.isNone { return nil }
        return try rhs()
    }
    public static func ||-> <A>(lhs: Self, rhs: @autoclosure () throws -> A) rethrows -> A? {
        if lhs.isSome { return nil }
        return try rhs()
    }
    public static func ||-> <A>(lhs: Self, rhs: @autoclosure () throws -> A?) rethrows -> A? {
        if lhs.isSome { return nil }
        return try rhs()
    }
}
