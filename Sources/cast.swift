//
//  cast.swift
//
//  Casting utility functions & operators.
//
//  Carson Rau - 2/8/22
//

#if canImport(Foundation)
import Foundation
#endif

@usableFromInline
internal enum _CastError: Error { case invalidCast }

@usableFromInline
internal func _cast<T, U>(_ value: T, to type: U.Type) -> U? {
    guard let result = value as? U else { return nil }
    return result
}

/// A strong cast from one type to another.
///
/// - Parameters:
///   - value: The value to cast.
///   - type: The type to cast to.
/// - Returns: The value after the cast.
/// - Throws: A `Swift.Error` subtype  if the cast fails.
@inlinable
public func cast<T, U>(_ value: T, to type: U.Type = U.self) throws -> U {
    guard let res = _cast(value, to: type) else { throw _CastError.invalidCast }
    return res
}

/// A strong cast from one type to another, with a default fallback value.
///
/// - Parameters:
///   - value: The value to cast.
///   - type: The type to cast to.
///   - default: The default value to return if the cast fails.
/// - Returns: The value after the cast, or the `default` value if the cast fails.
@inlinable
public func cast<T, U>(_ value: T, to type: U.Type = U.self, `default`: U) -> U {
    guard let res = _cast(value, to: type) else { return `default` }
    return res
}

/// Optional cast from one type to another.
///
/// - Parameters:
///   - value: The value to cast.
///   - type: The type to cast to.
/// - Returns: `nil` if the provided value is `nil`, or the value after casting.
/// - Throws: A `Swift.Error` subtype  if the cast fails.
@inlinable
public func cast<T, U>(_ value: T?, to type: U.Type = U.self) throws -> U? {
    guard let value = value else { return nil }
    #if canImport(Foundation)
    guard !(value is NSNull) else { return nil }
    #endif
    guard let result = _cast(value, to: type) else { throw _CastError.invalidCast }
    return result
}
