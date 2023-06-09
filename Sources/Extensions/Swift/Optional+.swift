//
//  Optional+.swift
//
//  Extensions to the Swift Optional type.
//
//  Created by Carson Rau on 6/8/23.
//

public enum _OptionalError: Error { case unwrap }

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
