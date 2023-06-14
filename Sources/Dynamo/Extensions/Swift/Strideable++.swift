//
//  Strideable+.swift
//
//  Extensions to the Swift Strideable type.
//
//  Carson Rau - 3/2/22
//

extension Strideable {
    /// Advances the current Strideable object by the specified distance.
    ///
    /// This function is marked with `@inlinable` to suggest to the compiler that it should
    /// consider inlining the function, even if it's defined in a different module.
    ///
    /// - Parameter distance: The distance to advance the current object. The value can be
    /// positive, negative or zero.
    ///
    /// This operation mutates the Strideable object it is called upon.
    @inlinable
    public mutating func advance(by distance: Stride) {
        self = self.advanced(by: distance)
    }
    /// Advances the current Strideable object by a distance of 1.
    ///
    /// This function is a convenience wrapper over the `advance(by:)` function with a
    /// predefined distance of 1. It mutates the Strideable object it is called upon.
    ///
    /// This function is marked with `@inlinable` to suggest to the compiler that it should
    /// consider inlining the function, even if it's defined in a different module.
    @inlinable
    public mutating func advance() {
        self.advance(by: 1)
    }
    /// Returns the predecessor of the current Strideable object.
    ///
    /// The predecessor is calculated by advancing the current object by a distance of -1.
    ///
    /// This function is marked with `@inlinable` to suggest to the compiler that it should
    /// consider inlining the function, even if it's defined in a different module.
    ///
    /// - Returns: The predecessor of the current Strideable object.
    @inlinable
    public func predecessor() -> Self {
        self.advanced(by: -1)
    }
    /// Returns the successor of the current Strideable object.
    ///
    /// The successor is calculated by advancing the current object by a distance of 1.
    ///
    /// This function is marked with `@inlinable` to suggest to the compiler that it should
    /// consider inlining the function, even if it's defined in a different module.
    ///
    /// - Returns: The successor of the current Strideable object.
    @inlinable
    public func successor() -> Self {
        self.advanced(by: 1)
    }
}
