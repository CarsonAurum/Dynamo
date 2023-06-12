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
    /// Create a new optional value wrapping the given value if the condition is true, otherwise `nil`.
    ///
    /// - Parameters:
    ///   - wrapped: The wrapped value to store in the new optional if the condition is true.
    ///   - condition: The condition to use when determining if the closure should be evaluated.
    /// - Throws: Any errors from the `wrapped` closure will be rethrown.
    @inlinable
    public init(_ wrapped: @autoclosure () throws -> Wrapped, if condition: Bool) rethrows {
        self = condition ? try wrapped() : nil
    }
    /// Create a new optional value wrapping the given optional value if the condition is true, otherwise `nil`.
    ///
    /// - Parameters:
    ///   - wrapped: The optional wrapped value to store in the new optional if the condition is true.
    ///   - condition: The condition to use when determining if the closure should be evaluated.
    /// - Throws: Any errors from the `wrapped` closure will be rethrown.
    @inlinable
    public init(_ wrapped: @autoclosure () throws -> Wrapped?, if condition: Bool) rethrows {
        self = condition ? try wrapped() : nil
    }
}

extension Optional {
    /// If the wrapped value is a singly wrapped optional, unwrap one layer of the optional.
    /// - Returns: The value if it is not `nil`, `Optional.none` otherwise. No optional nesting remains.
    public func compact<T>() -> T? where Wrapped == T? { self ?? .none }
    /// If the wrapped value is a doubly wrapped optional, unwrap two layers of the optional.
    /// - Returns: The value if it is not `nil`, `Optional.none` otherwise. No optional nesting remains.
    public func compact<T>() -> T? where Wrapped == T?? { (self ?? .none) ?? .none }
    /// If the wrapped value is a triply wrapped optional, unwrap three layers of the optional.
    /// - Returns: The value if it is not `nil`, `Optional.none` otherwise. No optional nesting remains.
    public func compact<T>() -> T? where Wrapped == T??? { ((self ?? .none) ?? .none) ?? .none }
    /// Use a given predicate closure to evaluate the wrapped value within this optional, if it exists.
    ///
    /// - Parameter predicate: The predicate function to execute when the wrapped value is not `nil`.
    /// - Returns: The wrapped value if `self` was not `nil` and the predicate evaluates to `true`. `Optional.none`
    ///   otherwise.
    /// - Throws: Any errors from the predicate will be rethrown.
    @inlinable
    public func filter(_  predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        try map(predicate) == .some(true) ? self : .none
    }
    /// The opposite of standard `Optional.flatMap()`, executing the closure only when the wrapped value is `nil`.
    ///
    /// - Parameter predicate: The closure to execute to provide a value when `self` is `nil`.
    /// - Returns: The value from the predicate if `self` is `nil`, or the wrapped value otherwise.
    /// - Throws: Any errors from the predicate will be rethrown.
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
    // swiftlint:disable force_unwrapping
    @inlinable
    public mutating func mutate<T>(_ transform: (inout Wrapped) throws -> T) rethrows -> T? {
        guard self != nil else { return nil }
        return try transform(&self!)
    }
    // swiftlint:enable force_unwrapping
    @discardableResult
    @inlinable
    public func onNone(_ f: () throws -> Void) rethrows -> Wrapped? {
        if isNone { try f() }
        return self
    }
    // swiftlint:disable self_binding
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
    // swiftlint:enable self_binding
    // swiftlint:disable force_unwrapping
    @inlinable
    public mutating func remove() -> Wrapped {
        defer { self = nil }
        return self!
    }
    // swiftlint:enable force_unwrapping
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
    // swiftlint:disable self_binding
    /// Attempt to unwrap this optional, returning the result, or throwing an error if unsuccessful.
    /// - Returns: The unwrapped value, if it exists.
    /// - Throws: An error if the unwrapping fails.
    @inlinable
    public func unwrap() throws -> Wrapped {
        guard let wrapped = self else { throw _OptionalError.unwrap }
        return wrapped
    }
    /// Attempt to unwrap this optional, returning the result, or throwing a given error if unsuccessful.
    /// - Parameter error: The error to throw if the unwrapping fails.
    /// - Returns: The unwrapped value, if it exists.
    /// - Throws: The given error if the unwrapping fails.k\
    @inlinable
    public func unwrapOrThrow(_ error: @autoclosure () throws -> Error) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw try error()
        }
    }
    // swiftlint:enable self_binding
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
