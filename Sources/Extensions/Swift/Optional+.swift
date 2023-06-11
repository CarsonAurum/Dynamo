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
}
