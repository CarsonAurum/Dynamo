//
//  Fail+.swift
//
//  Extensions to the Combine Fail type.
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Fail where Output == Any, Failure == Error {
    /// Construct a new failing publisher with the given error.
    ///
    /// - Parameter error: The error to wrap within a newly constructed future.
    public init(error: Failure) {
        self.init(outputType: Any.self, failure: error)
    }
}

#endif
