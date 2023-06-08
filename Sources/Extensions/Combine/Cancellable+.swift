//
//  Cancellable+.swift
//
//  Extensions to the SwiftUI Cancellable type.
//
//  Carson Rau - 6/8/23
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Cancellable {
    
    /// Perform type erasure on this cancellable object.
    ///
    /// - Returns: The type-erased object.
    public func eraseToAnyCancellable() -> AnyCancellable {
        AnyCancellable(self)
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension Task: Cancellable { }
#endif
