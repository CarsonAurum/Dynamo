//
//  Result.Publisher+.swift
//
// Extensions to the Combine Result.Publisher type
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Result.Publisher where Failure == Error {
    public init(_ output: () throws -> Success) {
        self = Result(catching: output).publisher
    }
}

#endif
