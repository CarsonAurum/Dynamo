//
//  Just+.swift
//
//  Extensions to the Combine Just type.
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Just {
    
    /// Constructs a new `Just` instance from the given closure.
    ///
    /// - Parameter output: A closure that produces a value of the `Output` type.
    public init(_ output: () -> Output) {
        self.init(output())
    }
}
#endif
