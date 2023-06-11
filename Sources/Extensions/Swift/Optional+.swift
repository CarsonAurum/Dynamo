//
//  Optional+.swift
//
//  Extensions to the Swift Optional type.
//
//  Carson Rau - 1/31/22
//

/// An error thrown when an optional cannot be successfully unwrapped by the functions provided in this package.
public enum _OptionalError: Error {
    /// The unwrapping error type.
    case unwrap
}

extension Optional {
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
}
